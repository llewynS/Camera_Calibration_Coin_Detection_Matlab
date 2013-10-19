function [diameter] = getdiametermm(houghcircles, pixels_2_mm_scale)
radius_pixels = houghcircles(:,3);
diameter = 2*pixels_2_mm_scale*radius_pixels;