function faces_and_bars(imgDir, width, height, window, leftfacepic, rightfacepic, leftpoints, rightpoints,reparterecibe)


%% Internal parameters of the function
% text
textsizebarnumbers = 30;
textsizereparterecibe = 60;
% color
whitecolor  = [255 255 255];
blackcolor  = [0 0 0];
greencolor  = [34 156 34]; %rgb(60,179,113) rgb(46,139,87)
orangecolor = [255 140 20];
% Size of each object, related to screen size (in RECT coordinates)
faceupper = height*.1; % upper limit of the face
facelower = height*.5; % lower limit of the face
% faces position
leftfacepos  = [width*.12, faceupper, width*.32, facelower]; % left face position
rightfacepos = [width*.62, faceupper, width*.82, facelower]; % right face position
leftframepos  = [leftfacepos(1)-width/200,  faceupper-width/200, leftfacepos(3)+width/200,  facelower+width/20]; % left frame position
rightframepos = [rightfacepos(1)-width/200, faceupper-width/200, rightfacepos(3)+width/200, facelower+width/20]; % right frame position
% bars position
leftbarpos   = [leftframepos(3)+width*0.03,  faceupper, leftframepos(3)+width*0.06,  rightframepos(4)]; % left bar position
rightbarpos  = [rightframepos(3)+width*0.03, faceupper, rightframepos(3)+width*0.06, rightframepos(4)]; % right bar position
leftinternalbarpos  = [leftbarpos(1)+width*0.002, faceupper+height*0.002, leftbarpos(3)-width*0.002,  leftbarpos(4)-width*0.002]; % white square inside left black bar
rightinternalbarpos = [rightbarpos(1)+width*0.002,faceupper+height*0.002, rightbarpos(3)-width*0.002, rightbarpos(4)-width*0.002]; % white square inside right black bar
numberbarseparation = width*0.007; % horizontal separation between bar and numbers
% left numbers and tick positions
leftnumber0pos    = [leftbarpos(3)+numberbarseparation, leftbarpos(4)];
leftnumber10pos   = [leftbarpos(3)+numberbarseparation, leftbarpos(2)+(leftbarpos(4)-leftbarpos(2))/4*3+height*0.01];
leftnumber20pos   = [leftbarpos(3)+numberbarseparation, leftbarpos(2)+(leftbarpos(4)-leftbarpos(2))/4*2+height*0.01];
leftnumber30pos   = [leftbarpos(3)+numberbarseparation, leftbarpos(2)+(leftbarpos(4)-leftbarpos(2))/4*1+height*0.01];
leftnumber40pos   = [leftbarpos(3)+numberbarseparation, leftbarpos(2)+height*0.01];
leftbartickpos10  = [leftbarpos(1)+width*0.002, leftnumber10pos(2)-height*.01, leftbarpos(3)-width*0.002, leftnumber10pos(2)-height*.01+height*0.002];
leftbartickpos20  = [leftbarpos(1)+width*0.002, leftnumber20pos(2)-height*.01, leftbarpos(3)-width*0.002, leftnumber20pos(2)-height*.01+height*0.002];
leftbartickpos30  = [leftbarpos(1)+width*0.002, leftnumber30pos(2)-height*.01, leftbarpos(3)-width*0.002, leftnumber30pos(2)-height*.01+height*0.002];
% right numbers and tick positions
rightnumber0pos    = [rightbarpos(3)+numberbarseparation, rightbarpos(4)];
rightnumber10pos   = [rightbarpos(3)+numberbarseparation, rightbarpos(2)+(rightbarpos(4)-rightbarpos(2))/4*3+height*0.01];
rightnumber20pos   = [rightbarpos(3)+numberbarseparation, rightbarpos(2)+(rightbarpos(4)-rightbarpos(2))/4*2+height*0.01];
rightnumber30pos   = [rightbarpos(3)+numberbarseparation, rightbarpos(2)+(rightbarpos(4)-rightbarpos(2))/4*1+height*0.01];
rightnumber40pos   = [rightbarpos(3)+numberbarseparation, rightbarpos(2)+height*0.01];
rightbartickpos10  = [rightbarpos(1)+width*0.002, rightnumber10pos(2)-height*.01, rightbarpos(3)-width*0.002, rightnumber10pos(2)-height*.01+height*0.002];
rightbartickpos20  = [rightbarpos(1)+width*0.002, rightnumber20pos(2)-height*.01, rightbarpos(3)-width*0.002, rightnumber20pos(2)-height*.01+height*0.002];
rightbartickpos30  = [rightbarpos(1)+width*0.002, rightnumber30pos(2)-height*.01, rightbarpos(3)-width*0.002, rightnumber30pos(2)-height*.01+height*0.002];
% colorbars. first convert points to bar coordinates
ycoords1 = rightnumber0pos(2); ycoords2 = rightnumber30pos(2); y1 = 0; y2 = 30;
slope = (y2-y1)/(ycoords2-ycoords1); b = y1-slope*ycoords1;
leftypos  = round((leftpoints-b)/slope);
rightypos = round((rightpoints-b)/slope);
% now calculate all bar coordinates
leftcolorbarpos    = [leftbarpos(1)+width*0.002,  leftypos-height*0.003,  leftbarpos(3)-width*0.002,  leftbarpos(4)-width*0.001];
rightcolorbarpos   = [rightbarpos(1)+width*0.002, rightypos-height*0.003, rightbarpos(3)-width*0.002, rightbarpos(4)-width*0.001];
% instructions position (reparte - recibe)
repartepos = [width*.15, height*0.7];
recibepos  = [width*.66,  height*0.7];

%% Screen structure (faces, squares, bars, numbers, etc)

% Left face
Screen('FillRect', window, blackcolor, leftframepos); % rectangulo fondo de cara
%             pic = face_picture_left{block}; pic = pic{1};
pic = leftfacepic; % pic = pic{1};
myimgfile=strcat(imgDir, filesep, pic);
ima2=imread(myimgfile, 'jpg');
Screen('PutImage', window, ima2,leftfacepos); % put image on screen
%             t0 = GetSecs;
% Left bar
% if face_face_picture_left{block} SI LA CARITA ES GORRITA
% NARANJA, VA BARRITA COLOR NARANJA
Screen('FillRect', window, blackcolor, leftbarpos); % rectangulo barra
Screen('TextSize', window, textsizebarnumbers);
Screen('FillRect', window, whitecolor, leftinternalbarpos); % rectangulo blanco, fondo de la barra
% Convert points to screen position
if strcmp(leftfacepic(3),'g'); col = greencolor; else col = orangecolor; end
Screen('FillRect', window, col, leftcolorbarpos); % rectangulo de puntaje en color
% Lines inside the bar, tick 10, 20 and 30
Screen('FillRect', window, blackcolor, leftbartickpos10);
Screen('FillRect', window, blackcolor, leftbartickpos20);
Screen('FillRect', window, blackcolor, leftbartickpos30);
% numeros al costado de la barra
DrawFormattedText(window, '0', leftnumber0pos(1),leftnumber0pos(2), blackcolor); % numeros al costado de la barra
DrawFormattedText(window, '10', leftnumber10pos(1),leftnumber10pos(2), blackcolor);
DrawFormattedText(window, '20', leftnumber20pos(1), leftnumber20pos(2), blackcolor);
DrawFormattedText(window, '30', leftnumber30pos(1),leftnumber30pos(2), blackcolor);
DrawFormattedText(window, '40', leftnumber40pos(1), leftnumber40pos(2), blackcolor);

% Cara derecha
Screen('FillRect', window, blackcolor, rightframepos); % rectangulo fondo de cara
% pic = face_picture_right{block}; pic = pic{1};
pic = rightfacepic; % pic = pic{1};
myimgfile=strcat(imgDir, filesep, pic);
ima3=imread(myimgfile, 'jpg');
Screen('PutImage', window, ima3,rightfacepos); % put image on screen
% Barrita derecha
Screen('FillRect', window, blackcolor, rightbarpos);
Screen('FillRect', window, whitecolor, rightinternalbarpos); % rectangulo blanco, fondo de la barra
if strcmp(rightfacepic(3),'g'); col = greencolor; else col = orangecolor; end
Screen('FillRect', window, col, rightcolorbarpos); % rectangulo de puntaje en color
% Lines inside the bar, tick 10, 20 and 30
Screen('FillRect', window, blackcolor, rightbartickpos10);
Screen('FillRect', window, blackcolor, rightbartickpos20);
Screen('FillRect', window, blackcolor, rightbartickpos30);
% numeros al costado de la barra
DrawFormattedText(window, '0', rightnumber0pos(1),rightnumber0pos(2), blackcolor);
DrawFormattedText(window, '10', rightnumber10pos(1),rightnumber10pos(2), blackcolor);
DrawFormattedText(window, '20', rightnumber20pos(1), rightnumber20pos(2), blackcolor);
DrawFormattedText(window, '30', rightnumber30pos(1),rightnumber30pos(2), blackcolor);
DrawFormattedText(window, '40', rightnumber40pos(1), rightnumber40pos(2), blackcolor);

if reparterecibe == 1;
    % Texto debajo de las caras
    Screen('TextSize', window, textsizereparterecibe);
    DrawFormattedText(window, 'REPARTE', repartepos(1), repartepos(2), blackcolor);
    DrawFormattedText(window, 'RECIBE',  recibepos(1), recibepos(2), blackcolor);
end

 
end

