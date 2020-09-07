function practice_third_party_punishment(imgDir, window, gen,endoColor,leftthumb,rightthumb, escape, spacebar, ek, ik, acepta, releasepausekey)

% Bloque 1: (durante la actualización de la barra se mantiene 1,5 seg. Solo en este bloque)
% Reparte endogrupo, recibe exogrupo
% Trials: 3 estímulos (tarjetas)
% 1) decisión injusta sin costo practica b1 (+4+0),
% 2) decisión equitativa practica b1(+2+2),
% 3) decisión injusta con costo practica b1 (+5+0).
% Bloque 2:
% Reparte exogrupo, recibe exogrupo
% Trials: 2 estímulos (tarjetas)
% 1) decisión injusta sin costo practica b2 (+3+0),
% 2) decisión injusta con costo practica b2 (+2+0).

% Para finalizar con la práctica, aparece una pantalla que pregunta al
% participante si necesita repetir una vez más el ejercicio (bloque 2) para
% mayor comprensión. Luego de los dos bloques se muestra la pantalla con el
% feedback final (puntos totales acumulados por cada uno de los personajes en la práctica).


%% Parameters
% leftthumb = 'up'; rightthumb = 'down';

if strcmp(gen,'m')
    
    if strcmp(endoColor,'g')
        
        leftfacepic{1}='m_g';
        rightfacepic{1}='m_o';
        
        leftfacepic{2}='m_o';
        rightfacepic{2}='m_o';
        
    elseif strcmp(endoColor,'o')
        
        leftfacepic{1}='m_o';
        rightfacepic{1}='m_g';
        
        leftfacepic{2}='m_g';
        rightfacepic{2}='m_g';
        
    end
    
elseif strcmp(gen,'f')
    
    if strcmp(endoColor,'g')
        
        leftfacepic{1}='f_g';
        rightfacepic{1}='f_o';
        
        leftfacepic{2}='f_o';
        rightfacepic{2}='f_o';
        
    elseif strcmp(endoColor,'o')
        
        leftfacepic{1}='f_o';
        rightfacepic{1}='f_g';
        
        leftfacepic{2}='f_g';
        rightfacepic{2}='f_g';
        
    end
end

% Times
timefirstscreen     = 1;
tfixcross           = 0.2;
timeafterfeedback   = 1; % tiempo luego de dar feedback numerico
timeafternewbars    = 1; % tiempo luego de actualizar barritas de puntaje
% Screen size
oldResolution = Screen('Resolution', 0);
width         = oldResolution.width;
height        = oldResolution.height;
% Bet position (tarjeta)
betpos       = [width*0.35,height*0.7,width*0.65,height*0.9];
% Thumbs up and Thumbs down position
lefttickpos  = [width*.02,  height*0.84, width*.12, height];
righttickpos = [width*.88, height*0.84, width*.98,  height];
% Bet result numbers position (e.g. +3)
leftgainpos  = [width*.194,  height*0.52];
rightgainpos = [width*.69, height*0.52];
% Alert sign position
alertpos = [betpos(1)-width*.1, betpos(2), betpos(1), betpos(4)];
% Text Sizes
textsizepoints = 100;
textsizecross  = 80;
whitecolor = [255 255 255];
blackcolor = [0 0 0];
violetcolor = [159 0 255];

resp  = nan(2,3);

% bet
% 1) decisión injusta sin costo practica b1 (+4+0),
% 2) decisión equitativa practica b1(+2+2),
% 3) decisión injusta con costo practica b1 (+5+0).
% Bloque 2:
% Reparte exogrupo, recibe exogrupo
% Trials: 2 estímulos (tarjetas)
% 1) decisión injusta sin costo practica b2 (+3+0),
% 2) decisión injusta con costo practica b2 (+2+0).

tarjeta(1,1) = {'decisión_injusta_SIN_costo_práctica_b1.jpg'}; % 4-0
tarjeta(1,2) = {'decisión_equitativa_práctica_b1.jpg'}; %        2-2
tarjeta(1,3) = {'decisión_injusta_CON_costo_práctica_b1.jpg'}; % 5-0
tarjeta(2,1) = {'decisión_injusta_SIN_costo_práctica_b2.jpg'}; % 3-0
tarjeta(2,2) = {'decisión_injusta_CON_costo_práctica_b2.jpg'}; % 2-0


% Pantalla de bienvenida

Screen('FillRect', window, whitecolor, [0 0 width, height]);
Screen('TextSize', window, textsizepoints);
DrawFormattedText(window, 'BIENVENIDOS!', 'center','center',blackcolor); % puntaje ganado
Screen('Flip',window); % now visible on screen
% Wait response
flag = 1;
while flag
    [keyIsDown,~, keyCode] = KbCheck;
    if keyIsDown
        if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
        else
            if sum(find(keyCode)== spacebar)
                break
            end
        end
    end
end

for times = 1:2
    
    for block=1:2
        
        leftpoints =  0;
        rightpoints = 0;
        
        for trial=1:3
            
            if block == 1 || (block == 2 && trial == 1) || (block == 2 && trial == 2)
                
                %% First screen, faces with bars representing points.
                Screen('FillRect', window, whitecolor, [0 0 width, height]);
                
                reparterecibe = 1;
                faces_and_bars(imgDir, width, height, window, leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
                
                
                Screen('Flip',window); % now visible on screen
                WaitSecs(timefirstscreen);
                % Wait Space Bar pressing ONLY if trial == 1
                if trial == 1
                    WaitSecs(1);
                    flag = 1;
                    while flag
                        [keyIsDown,~, keyCode] = KbCheck;
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
                
                %% tarjeta (tarjeta)
                
                reparterecibe = 0;
                faces_and_bars(imgDir, width, height, window,leftfacepic{block}, rightfacepic{block}, leftpoints, rightpoints, reparterecibe)
                
                % tarjeta
                pic = tarjeta{block,trial}; % pic = pic{1};
                myimgfile=strcat(imgDir, filesep, pic);
                ima4=imread(myimgfile, 'jpg');
                Screen('PutImage', window, ima4, betpos); % put image on screen
                if strcmp(tarjeta{block,trial},'decisión_injusta_CON_costo_práctica_b1.jpg') || strcmp(tarjeta{block,trial},'decisión_injusta_CON_costo_práctica_b2.jpg')
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
                flag = 1;
                while flag
                    [keyIsDown,~, keyCode] = KbCheck;
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
                
                %% Actualizacion de puntaje
                if resp(block,trial) == acepta && block == 1 && trial == 1; % accept fair tarjeta
                    ptsshowed = {'+4','+0'};
                    leftpoints = leftpoints + 4; rightpoints = rightpoints + 0;
                elseif resp(block,trial) == acepta && block == 1 && trial == 2 % accept unfair tarjeta
                    leftpoints = leftpoints + 2; rightpoints = rightpoints + 2;
                    ptsshowed = {'+2','+2'};
                elseif resp(block,trial) == acepta && block == 1 && trial == 3 % accept unfair tarjeta
                    leftpoints = leftpoints + 5; rightpoints = rightpoints + 0;
                    ptsshowed = {'+5','+0'};
                elseif resp(block,trial) == acepta && block == 2 && trial == 1
                    leftpoints = leftpoints + 3; rightpoints = rightpoints + 0;
                    ptsshowed = {'+3','+0'};
                elseif resp(block,trial) == acepta && block == 2 && trial == 2
                    leftpoints = leftpoints + 2; rightpoints = rightpoints + 0;
                    ptsshowed = {'+2','+0'};
                else
                    ptsshowed = {'+0','+0'};
                end % else do nothing
                
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
                % presione tecla control
                if strcmp(tarjeta{block,trial},'decisión_injusta_CON_costo_práctica_b1.jpg') || strcmp(tarjeta{block,trial},'decisión_injusta_CON_costo_práctica_b2.jpg')
                    flag = 1;
                    while flag
                        [keyIsDown, ~, keyCode] = KbCheck;
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
        end
        
        %% Al terminar el bloque, doy feedback de los puntos acumulados
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
            [keyIsDown,~, keyCode] = KbCheck;
            if keyIsDown
                if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
                else
                    if find(keyCode)== spacebar; break
                    end
                end
            end
        end
    end
    % Terminado el primer ciclo, pregunto si quiere hacer practica
    % nuevamente
    if times == 1
        Screen('FillRect', window, whitecolor, [0 0 width, height]);
        Screen('TextSize', window, textsizepoints);
        DrawFormattedText(window, 'QUERES PRACTICAR DE NUEVO?', 'center','center',blackcolor); % puntaje ganado
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
        flag = 1;
        while flag
            [keyIsDown,~, keyCode] = KbCheck;
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
        if resp(block,trial) == acepta
        else break
        end
    end
end

% La practica termina dando la bienvenida al juego posta

Screen('FillRect', window, whitecolor, [0 0 width, height]);
Screen('TextSize', window, textsizepoints);
DrawFormattedText(window, 'EMPIEZA EL JUEGO !', 'center','center',blackcolor); % puntaje ganado
Screen('Flip',window); % now visible on screen
% Wait response
flag = 1;
while flag
    [keyIsDown,~, keyCode] = KbCheck;
    if keyIsDown
        if find(keyCode) == escape; Priority(0); ShowCursor; Screen('CloseAll'); return;
        else
            if sum(find(keyCode)== spacebar)
                break
            end
        end
    end
end