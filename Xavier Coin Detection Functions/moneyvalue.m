function [total_money_value, num] = moneyvalue(diameters,scale)
% Gives total, as well as individual 5c, 10c, 20c, 50c, 1aud, 2aud
num = [0 0 0 0 0 0];
five_diameter = 19.41;
ten_diameter = 23.6;
twenty_diameter =28.65;
fifty_diameter = 31.65;
one_diameter =25;
two_diameter = 20.5;
error = 2*scale;

% Correlates coin diameters with their value
for i = 1:length(diameters)
    if (five_diameter-error) < diameters(i) && diameters(i) < (five_diameter+error)
        num(1) = num(1) + 1;
    elseif (ten_diameter-error) < diameters(i) && diameters(i) < (ten_diameter+error)
        num(2) = num(2) + 1;
    elseif (twenty_diameter-error) < diameters(i) && diameters(i) < (twenty_diameter+error)
        num(3) = num(3) + 1;
    elseif (fifty_diameter-error) < diameters(i) && diameters(i) < (fifty_diameter+error+0.2)
        num(4) = num(4) + 1;
    elseif (one_diameter-error) < diameters(i) && diameters(i) < (one_diameter+error)
        num(5) = num(5) + 1;
    elseif (two_diameter-error) < diameters(i) && diameters(i) < (two_diameter+error+0.2)
        num(6) = num(6) + 1;
    end
end
% Sum all the individual coins to find their value
total_money_value = 0.05*num(1)+0.1*num(2)+0.2*num(3)+0.5*num(4)+num(5)+2*num(6);

        
            
   