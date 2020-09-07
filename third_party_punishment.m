function third_party_punishment(debug)

% third_party_punishment, written by Agustin Petroni, August 2017
    
% Recordar, para probar teclado, escribir KbDemo.
% Para salir de KbDemo, presionar Ctrl+c

%% Parameters

% Times
timefirstscreen     = 1.5; % Initial screen
tfixcross           = 0.5;
timeafterfeedback   = 1; % Time after feedback
timeafternewbars    = 0; % Time after new bars with point appeared
% Screen size
oldResolution = Screen('Resolution', 0);
width         = oldResolution.width;
height        = oldResolution.height;
% Bet position (card)
betpos       = [width*0.35,height*0.7,width*0.65,height*0.9];
% Thumbs up and Thumbs down position
lefttickpos  = [width*.02,  height*0.84, width*.12, height];
righttickpos = [width*.88, height*0.84, width*.98,  height];
% Bet result numbers position (e.g. +3)
leftgainpos  = [width*.19,  height*0.52];
rightgainpos = [width*.69, height*0.52];
% Alert sign position
alertpos = [betpos(1)-width*.1, betpos(2), betpos(1), betpos(4)];
% Text Sizes
textsizepoints = 100;
textsizecross  = 80;
whitecolor = [255 255 255];
blackcolor = [0 0 0];
violetcolor = [159 0 255];

%% Directories and keys (dependent on the system and terminal)

if IsWin % Chu's machine.
    dataDir         = '/Users/luz/CO/data';
    imgDir          = '/Users/luz/CO/images';
    escape          = 41; % Check this
    ek              = 8;
    ik              = 12;
    spacebar        = 66; % Averiguar codigos con KbDemo (para salir de KbDemo presionar Ctrl+c)
    releasepausekey = 34;
else % agus machine (linux)
    dataDir         = '/home/agustin/Desktop/third_party_punishment/data';
    imgDir          = '/home/agustin/Desktop/third_party_punishment/images';
    escape          = 10;
    ek              = 27;
    ik              = 32;
    spacebar        = 66;
    releasepausekey = 34;
end

snum = length(dir(dataDir));
%% Input window with subject infrmation

try
    prompt = {'Nombre', 'Genero', 'Color elegido','Teclas de respuesta'};
    
    dlg_title           = 'TPP';                     % title of the input dialog box
    num_lines           = 1;                                      % number of input lines
    default             = {'mi nombre completo', 'varon', 'verde', 'acepta-rechaza'}; % default values
    options.Resize      = 'on';
    options.WindowStyle = 'normal';
    
    savestr             = inputdlg(prompt, dlg_title, num_lines, default, options);
    
    startData.subjID  = savestr{1};
    startData.gender  = savestr{2};
    startData.color   = savestr{3};
    startData.keys    = savestr{4};
    
    savedir = [dataDir filesep startData.subjID '_' num2str(round(rand*100))];
    
    mkdir(savedir);
    
    %% Use entered subject and experiment information to define variables
    
    % Select Gender and Color. Ingroup or Outgrup
    if strcmp(startData.gender,'varon')==1; gen = 'm';
    elseif strcmp(startData.gender,'mujer')==1; gen = 'f';
    else disp('%%% ERROR: gender input not recognized'); sca; return;
    end
    if strcmp(startData.color,'verde')==1; endoColor = 'g'; exoColor = 'o';
    elseif strcmp(startData.color,'naranja')==1; endoColor = 'o'; exoColor = 'g';
    else disp('%%% ERROR: color input not recognized'); sca; return;
    end
    
    % Response keys order
    if strcmp(startData.keys,'acepta-rechaza')==1; acepta = ek ; leftthumb = 'up'; rightthumb = 'down';
    elseif strcmp(startData.keys,'rechaza-acepta')==1; acepta = ik; leftthumb = 'down'; rightthumb = 'up';
    else disp('%%% ERROR: keys input order not recognized'); sca; return;
    end
    
    
    %%
    
    HideCursor(); % hides cursor
    KbName('UnifyKeyNames'); % used for cross-platform compatibility of keynaming
    KbQueueCreate; % creates cue using defaults
    KbQueueStart;  % starts the cue
    
    [window, ~] = Screen('OpenWindow', 0);
%     [window, ~] = Screen('OpenWindow', 0, [], [width/2-320, height/2-240, width/2+320, height/2+240]);
%     [window, ~] = Screen('OpenWindow', 0, [], [width/2-640, height/2-480, width/2+640, height/2+480]);
    
    
    % 4 Blocks, 7 trials each block
    resp  = nan(4,7);
    RT    = nan(4,7);
    pts   = nan(4,7,2);
    
    % Aleatorization: latin square
    [leftfacepic, rightfacepic, bet, groups_per_block] = aleatorization_latin_square(snum, gen, endoColor, exoColor);
    
    % Practice
    practice_third_party_punishment(imgDir, window, gen, endoColor, leftthumb, rightthumb, escape, spacebar, ek, ik, acepta, releasepausekey)
    
    
    for block=1:4
        
        leftpoints =  0;
        rightpoints = 0;
        
        for trial=1:7
            
            %             while KbCheck; end % clear keyboard queue
            
            %% First screen, faces with bars representing points.
            Screen('FillRect', window, whitecolor, [0 0 width, height]); % rectangulo de puntaje en color
            
            reparterecibe = 1;
            
            faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
            
            Screen('Flip',window); % now visible on screen
            WaitSecs(timefirstscreen);
            % Wait Space Bar pressing ONLY if trial == 1
            if trial == 1
                WaitSecs(1);
                flag = 1;
                while flag
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                        else
                            if find(keyCode)== spacebar; break
                            end
                        end
                    end
                end
            end
            
            %% Fixation cross 200 ms
            Screen('TextSize', window, textsizecross);
            DrawFormattedText(window, '+', 'center','center');
            Screen('Flip',window); % now visible on screen
            WaitSecs(tfixcross)
            
            %% Bet (tarjeta)
            reparterecibe = 0;
            
            faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
            
            % Bet
            pic = bet{block,trial}; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima4=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima4, betpos); % put image on screen
            if strcmp(bet{block,trial},'unfair_with_cost');
                pic = 'alerta';
                myimgfile=strcat(imgDir, filesep, pic);
                ima9=imread(myimgfile, 'jpg');
                Screen('PutImage', window, ima9, alertpos); % put image on screen
            end
            % Imagenes de thumb up y down para guiar respuestas.
            pic = leftthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima5=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima5, lefttickpos); % put image on screen
            pic = rightthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima6=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima6, righttickpos); % put image on screen
            Screen('Flip',window); % now visible on screen
            % Wait response
            t0 = GetSecs;
            flag = 1;
            while flag
                [keyIsDown, secs, keyCode] = KbCheck;
                if keyIsDown
                    if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                    else
                        if sum(find(keyCode)== ek) || sum(find(keyCode) == ik)
                            resp(block,trial) = find(keyCode);
                            break
                        end
                    end
                end
            end
            
            RT(block,trial) = secs - t0;
            
            %           WaitSecs(1);
            %% Actualizacion de puntaje
            if resp(block,trial) == acepta && strcmp(bet(block,trial),'fair'); % accept fair bet
                ptsshowed = {'+3','+3'};
                leftpoints = leftpoints + 3; rightpoints = rightpoints + 3;
            elseif resp(block,trial) == acepta && ~strcmp(bet(block,trial),'fair') % accept unfair bet
                leftpoints = leftpoints + 6; rightpoints = rightpoints + 0;
                ptsshowed = {'+6','+0'};
            else
                ptsshowed = {'+0','+0'};
            end % else do nothing
            
            pts(block, trial, 1) = leftpoints;
            pts(block, trial, 2) = rightpoints;
            
            %% Feedback
            reparterecibe = 0;
            
            faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
            
            % Imagenes de thumbs up y down para guiar respuestas.
            pic = leftthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima5=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima5, lefttickpos); % put image on screen
            pic =  rightthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima6=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima6,righttickpos); % put image on screen
            % Feedback
            Screen('TextSize', window, textsizepoints);
            DrawFormattedText(window, ptsshowed{1},  leftgainpos(1), leftgainpos(2), whitecolor); % puntaje ganado
            DrawFormattedText(window, ptsshowed{2},  rightgainpos(1), rightgainpos(2), whitecolor); % puntaje ganado
            Screen('Flip',window); % now visible on screen
            % KbQueueWait();  %waits for a key-press
            %             WaitSecs(0.5);
            WaitSecs(timeafterfeedback);
            
            %% Actualizacion de las barritas. Desaparecen los numeros debajo
            % de las caras y cambian de tamanio las barritas, si
            % corresponde.
            reparterecibe = 0;
            
            faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
            
            % Imagenes de thumbs up y down para guiar respuestas.
            pic = leftthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima5=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima5,lefttickpos); % put image on screen
            pic =  rightthumb; % pic = pic{1};
            myimgfile=strcat(imgDir, filesep, pic);
            ima6=imread(myimgfile, 'jpg');
            Screen('PutImage', window, ima6,righttickpos); % put image on screen
            Screen('Flip',window); % now visible on screen
            WaitSecs(timeafternewbars)
            
            % Si era tarjeta injusta con costo, espera hasta que se
            % presione tecla p (o la que se quiera, poner codigo en los parametros)
            if strcmp(bet{block,trial},'unfair_with_cost');
                flag = 1;
                while flag
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                        else
                            if find(keyCode)== releasepausekey; break
                            end
                        end
                    end
                end
            end
            
        end
        
        %% Al terminar el bloque, doy feedback de los puntos acumulados
        %         Screen('TextSize', window, textsizecross);
        % Fondo violeta
        Screen('FillRect', window, violetcolor, [0 0 width, height]); % rectangulo de puntaje en color
        reparterecibe = 1;
        
        faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
        
        % Feedback
        Screen('TextSize', window, textsizepoints);
        DrawFormattedText(window, ['+',num2str(leftpoints)],  leftgainpos(1)-width*.02,  leftgainpos(2), whitecolor); % puntaje ganado
        DrawFormattedText(window, ['+',num2str(rightpoints)], rightgainpos(1)-width*.002, rightgainpos(2), whitecolor); % puntaje ganado
        Screen('Flip',window); % now visible on screen
        
        % Esperar a que presione tecla p (o la que se quiera, poner codigo en los parametros)
        flag = 1;
        while flag
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                else
                    if find(keyCode)== spacebar; break
                    end
                end
            end
        end
    end
    
    % Guardo datos
    conditions_order = groups_per_block;
    save([savedir filesep 'comportamiento.mat'], 'resp', 'RT', 'startData', 'conditions_order')
    
    Screen('FillRect', window, whitecolor, [0 0 width, height]); % rectangulo blanco
    DrawFormattedText(window,'Gracias por participar','center','center', blackcolor);
    Screen('Flip',window);
    flag = 1;
            while flag
                [keyIsDown, ~, keyCode] = KbCheck;
                if keyIsDown
                    if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                    end
                end
            end
    ShowCursor(); %shows the cursor
    Screen('CloseAll'); %Closes Screen
    
    while KbCheck; end % clear keyboard queue
    
catch ME
    
    if debug == 1
        PsychDebugWindowConfiguration(-1)
    end
    
    Screen('CloseAll')
    ShowCursor;
    disp('%%% error')
    ME.stack(1)
    ME.message
    keyboard
    
    while KbCheck; end % clear keyboard queue
    
    save([dataDir filesep startData.subjID filesep 'comportamiento.mat'], 'resp', 'RT', 'startData', 'conditions_order');
    
end