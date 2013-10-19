function choose_n_images(rgb_images, n)
    rand_nums=randperm(size(rgb_images,4));
    rand_nums=sort(rand_nums(1:n));
    for i = 1:length(rand_nums)
        rgb=uint8(rgb_images(:,:,:,rand_nums(i)));
        imwrite(rgb,strcat('rgb_',num2str(i),'.jpg'));
    end
end
