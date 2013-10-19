function [RGBValues,HSVValues,YCbCrValues] = seperatecolous(ammended_houghcircles,image)
j=1;
k=1;
[m,n] = size(houghcircles);
for i = 1:m
    row = houghcircles(i,:);
    x= row(1);
    y= row(2);
    RGB = impixel(image,x,y);
    RGBValues(:,:,:,i)=RGB;
    HSV=rgb2hsv(RGB);
    HSVValues(:,:,:,i)=HSV;
    YCbCr=rgb2ycbcr(RGB);
    YCbCrValues(:,:,:,i)=YCbCr;
end
end