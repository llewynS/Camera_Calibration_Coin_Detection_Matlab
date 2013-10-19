function [image] = transformfinal(image_grid,checkerboard_width,image_name)
input_points=obtaininputslarge(image_grid);
base_points=generatebaseinputslarge(checkerboard_width);
tform = cp2tform(input_points,base_points,'projective');
image =  imtransform(imread(image_name),tform);
%imshow(image)
end