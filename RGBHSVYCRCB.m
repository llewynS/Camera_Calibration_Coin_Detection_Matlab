%reads in the captured image
colour=imread('rgb_coloure.jpg');
%Finds the centres of the colour chart
[Centres, Colours]=CCFind(colour);
%obtains the RGB values for the colour chart
for i = 1:24
    temp=impixel(colour,Centres(i+24),Centres(i));
    eval(['RGBChart_' num2str(i) ' =temp;'])
end
for i=1:24
    eval(['HSV_' num2str(i) ' =rgb2hsv(RGBChart_' num2str(i) ');']);
end
for i=1:24
    eval(['YCbCr_' num2str(i) ' =rgb2ycbcr(RGBChart_' num2str(i) ');']);
end