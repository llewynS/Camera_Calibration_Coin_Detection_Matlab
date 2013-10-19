function [base_points] = generatebaseinputslarge(checkerboard_size)
base_points = [0 0 ; 0 checkerboard_size*3 ; checkerboard_size*3 0 ; checkerboard_size*3 checkerboard_size*3];
end