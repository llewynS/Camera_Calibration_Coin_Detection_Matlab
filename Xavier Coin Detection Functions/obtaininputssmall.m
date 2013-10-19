function [input_points] = obtaininputssmall(checkerboard_points)
p1 = [checkerboard_points(1,21) checkerboard_points(2,21)];
p2 = [checkerboard_points(1,22) checkerboard_points(2,22)];
p3 = [checkerboard_points(1,27) checkerboard_points(2,27)];
p4 = [checkerboard_points(1,28) checkerboard_points(2,28)];
input_points = [p1(1) p1(2) ; p2(1) p2(2) ; p3(1) p3(2) ; p4(1) p4(2)];
end