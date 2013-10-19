%Calibration image
fprintf('\n Callibrating to grid \n')
image1 = transformfinal(x_30,100,'rgb_30.jpg');
fprintf('\n Finding scale of pixels to mm \n')
scale = pixels2mmL(image1)
%Corrected image with coins
fprintf('\n Adjusting coin image \n')
GetScene;
image2 = transformfinal(x_30,100,'rgb_scene.jpg');

%Start process to find coins
[max,min] = houghcirclemaxmin(scale);
fprintf('\n Finding coins \n')
circles = houghcircles(image2,min,max,0.4);
houghcircles(image2,min,max,0.4)
%circles = houghcircles(image2,10,50,0.4);
%Remove any circles that are clearly too dark
fprintf('\n Remove dark circles \n')
ammended_circles = removebadcircles(circles,image2)
%ammended_circles = circles;
%Transfer our pixel space into world space using our calibration
fprintf('\n Change the circle diameters to mm \n')
diameter = getdiametermm(ammended_circles,scale)
fprintf('\n Calc our money! \n')
[total, num] = moneyvalue(diameter,scale);
total
num
