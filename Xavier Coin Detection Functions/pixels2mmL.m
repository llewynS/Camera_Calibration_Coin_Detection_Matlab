function [scale] = pixels2mmL(image)
c = corner(rgb2gray(image),'MinimumEigenvalue',50);
j = 1;
[m,n]=size(c);
for i=1:m
    while j <m
        if c(i,2)<c(j,2)
            temp = c(i,:);
            c(i,:)=c(j,:);
            c(j,:)=temp;
            j=1;
        else
            j=j+1;
        end
    end
    j=1;
end
tolerance=6;
k=1;
i=1;

while i<m
    for j=i+1:m
        if abs(c(i,2)-c(j,2))<tolerance
            d(k)=sqrt((c(i,2)-c(j,2))^2+(c(i,1)-c(j,1))^2);
            k=k+1;
        else
            break
        end
    end
    i=j;
end
d=sort(d);
for i = 1:length(d)
    if d(i) < 10
        d2=d(i+1:end);
    end
end
final = d2(1);
for i = 2:length(d2)
    if d2(i) < d2(1)+10
        final(i) = d2(i);
    else
        break
    end
end
mean(final);
scale = 28/mean(final);
        