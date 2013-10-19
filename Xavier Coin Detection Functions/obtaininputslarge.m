function [input_points] = obtaininputslarge(checkerboard_points)
p1 = [checkerboard_points(1,14) checkerboard_points(2,14)];
p2 = [checkerboard_points(1,17) checkerboard_points(2,17)];
p3 = [checkerboard_points(1,32) checkerboard_points(2,32)];
p4 = [checkerboard_points(1,35) checkerboard_points(2,35)];
input_points = [p1(1) p1(2) ; p2(1) p2(2) ; p3(1) p3(2) ; p4(1) p4(2)];
end