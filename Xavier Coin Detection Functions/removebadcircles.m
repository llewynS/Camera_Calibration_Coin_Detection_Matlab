function [ammended_houghcircles] = removebadcircles(houghcircles,image)
j=1;
[m,n] = size(houghcircles);
for i = 1:m
    row = houghcircles(i,:);
    x= row(1);
    y= row(2);
    RGB = impixel(image,x,y);
    
    if (RGB(1)>40) && (RGB(2)>25) && (RGB(3)>25)
        ammended_houghcircles(j,:) = houghcircles(i,:);
        j = j+1;
    end
end
end

        