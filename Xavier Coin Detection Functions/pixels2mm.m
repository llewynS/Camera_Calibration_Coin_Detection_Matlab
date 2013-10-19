function [scale] = pixels2mm(image)
c = corner(rgb2gray(image),'MinimumEigenvalue',50);
for i=1:50
    for j = 1:i-1
        if c(i,2) > c(j,2)
            c(i,:) = c(j,:);
            break
        end
    end
end
