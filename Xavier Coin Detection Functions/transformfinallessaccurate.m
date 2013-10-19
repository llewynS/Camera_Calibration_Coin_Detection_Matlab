function [image] = transformfinallessaccurate(image_grid,checkerboard_width,image_name)
input_points=obtaininputssmall(image_grid);
base_points=generatebaseinputssmall(checkerboard_width);
tform = cp2tform(input_points,base_points,'projective');
image =  imtransform(imread(image_name),tform);
imshow(image)
end