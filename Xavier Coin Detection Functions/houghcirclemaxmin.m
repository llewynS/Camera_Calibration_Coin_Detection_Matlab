function [max, min] = houghcirclemaxmin(scale)
% Steps to get max min:
% 1. Get max and min diameters of coins in mm
% 2. Divide by scale to convert to pixels
% 3. Add a buffer for slightly larger or smaller circles
% 4. Divide by 2 to get radius
min = round(((19.41/scale)-7)/2)
max = round(((31.65/scale)+7)/2)
end