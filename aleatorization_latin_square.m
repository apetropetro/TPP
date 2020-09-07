function [facepictureleft, facepictureright, bet, groups_per_block] = aleatorization_latin_square(snum,gen, endoColor, exoColor)

% Tipo de estímulos (tarjetas)
% a) 3 tarjetas de decisiones injustas sin costo: tarjeta con 6 caramelos del lado izquierdo y 0 del lado derecho.
% b) 3 tarjetas de decisiones injustas con costo: tarjeta con 6 caramelos del lado izquierdo y 0 del lado derecho, y además, un signo de exclamación que indica el costo.
% c) 1 tarjeta de decisiones equitativas: tarjeta con 3 caramelos del lado izquierdo y 3 del lado derecho.

% Parámetros para aleatorizar la presentación de estímulos:
% Las opciones “a y b” no pueden repetirse más de 2 veces seguidas (por ejemplo, trials 3 y 4, pero no trials 3, 4 y 5).
% La opción “c” puede aparecer solo en trials 2, 3, 4 o 5.
%
% Condiciones
% 1 Endo-grupo/Exo- grupo
% 2 Endo-grupo/Endo- grupo
% 3 Exo-grupo/Exo- grupo
% 4 Exo-grupo/Endo- grupo
%
% Cuadrado latino
% Primer orden de presentación:  3 _ 2 _ 4 _ 1
% Segundo orden de presentación: 2 _ 1 _ 3 _ 4
% Tercer orden de presentación:  4 _ 3 _ 1 _ 2
% Cuarto orden de presentación:  1 _ 4 _ 2 _ 3

% Dependiendo en que numero de sujeto estemos testeando, va a correr alguna
% de las 4 aleatorizaciones del cuadrado latino

order1 = 1:4:200; order2 = 2:4:200; order3 = 3:4:200;

if find(snum==order1) ~= 0 % 3_2_4_1
    
    facepictureleft(1)= {[gen '_' exoColor]};  facepictureright(1)= {[gen '_' exoColor]};  groups_per_block(1,:) = {'exo','exo'};
    facepictureleft(2)= {[gen '_' endoColor]}; facepictureright(2)= {[gen '_' endoColor]}; groups_per_block(2,:) = {'endo','endo'};
    facepictureleft(3)= {[gen '_' exoColor]};  facepictureright(3)= {[gen '_' endoColor]}; groups_per_block(3,:) = {'exo','endo'};
    facepictureleft(4)= {[gen '_' endoColor]}; facepictureright(4)= {[gen '_' exoColor]};  groups_per_block(4,:) = {'endo','exo'};
    
elseif find(snum==order2) ~= 0 % 2_1_3_4
    
    facepictureleft(1)= {[gen '_' endoColor]}; facepictureright(1)= {[gen '_' endoColor]}; groups_per_block(1,:) = {'endo','endo'};
    facepictureleft(2)= {[gen '_' endoColor]}; facepictureright(2)= {[gen '_' exoColor]};  groups_per_block(2,:) = {'endo','exo'};
    facepictureleft(3)= {[gen '_' exoColor]};  facepictureright(3)= {[gen '_' exoColor]};  groups_per_block(3,:) = {'exo','exo'};
    facepictureleft(4)= {[gen '_' exoColor]};  facepictureright(4)= {[gen '_' endoColor]}; groups_per_block(4,:) = {'exo','endo'};
    
elseif find(snum==order3) ~= 0 % 4_3_1_2
    
    facepictureleft(1)= {[gen '_' exoColor]};  facepictureright(1)= {[gen '_' endoColor]}; groups_per_block(1,:) = {'exo','endo'};
    facepictureleft(2)= {[gen '_' exoColor]};  facepictureright(2)= {[gen '_' exoColor]};  groups_per_block(2,:) = {'exo','exo'};
    facepictureleft(3)= {[gen '_' endoColor]}; facepictureright(3)= {[gen '_' exoColor]};  groups_per_block(3,:) = {'endo','exo'};
    facepictureleft(4)= {[gen '_' endoColor]}; facepictureright(4)= {[gen '_' endoColor]}; groups_per_block(4,:) = {'endo','endo'};
    
else % 1_4_2_3
    
    facepictureleft(1)= {[gen '_' endoColor]}; facepictureright(1)= {[gen '_' exoColor]};  groups_per_block(1,:) = {'endo','exo'};
    facepictureleft(2)= {[gen '_' exoColor]};  facepictureright(2)= {[gen '_' endoColor]}; groups_per_block(2,:) = {'exo','endo'};
    facepictureleft(3)= {[gen '_' endoColor]}; facepictureright(3)= {[gen '_' endoColor]}; groups_per_block(3,:) = {'endo','endo'};
    facepictureleft(4)= {[gen '_' exoColor]};  facepictureright(4)= {[gen '_' exoColor]};  groups_per_block(4,:) = {'exo','exo'};
    
end


% Trial aleatorization (bets)

trls = [0 1 1 1 2 2 2]; % 0: fair; 1: unfair with no cost; 2: unfair with cost
shuf = nan(4,7);

for b=1:4% for each of two blocks
    
    repet = [];
    done  = 1;
    while done
        sh = shuffle(trls);
        % Check for 3 times repetitions and avoiding fair bet in positions 1, 6 and 7
        for j=1:length(sh)-2
            if ( sh(j) == sh(j+1) && sh(j) == sh(j+2) ) || ( sh(1) == 0 || sh(6) == 0 || sh(7) == 0 )  
                repet(j) = 1; % 3 times repetition found, or fair bet found in positions 1 or 6 or 7
            else
                repet(j) = 0;
            end
        end
        % If there are no 3 times repetitions of any element, we exit while loop.
        if sum(repet)==0
            done = 0;
        end
    end
    
    shuf(b,:) = sh;
    
end
% shuf is the shuffled sequence of indexes of trials for a block that avoids
% 3 times repetitions.
bet = cell(4,7);

for block = 1:4
    for trial = 1:7
        if shuf(block,trial)==0
            bet(block,trial) = {'fair'};
        elseif shuf(block,trial)==1
            bet(block,trial) = {'unfair_no_cost'};
        else
            bet(block,trial) = {'unfair_with_cost'};
        end
    end
end
