function pyramid_blendingg(img1, img2)

    [~,n,~] = size(img1);
    mask = zeros(size(img1));
    mask(:,1:n/2,:) = 1;
    blended_without_pyramid = (img1 .* mask) + (img2 .* abs(1 - mask));
    blended_with_pyramid_1 = blend_rgb(img1, img2, 1);
    blended_with_pyramid_3 = blend_rgb(img1, img2, 3);
    blended_with_pyramid_6 = blend_rgb(img1, img2, 6);

    figure()
    subplot(1,4,1)
    imshow(blended_without_pyramid,[])
    title('blended without pyramid')
    subplot(1,4,2)
    imshow(blended_with_pyramid_1,[])
    title({'blended with pyramid' ,'numbers of pyramid levels = 1'})
    subplot(1,4,3)
    imshow(blended_with_pyramid_3,[])
    title({'blended with pyramid' ,'numbers of pyramid levels = 3'})
    subplot(1,4,4)
    imshow(blended_with_pyramid_6,[])
    title({'blended with pyramid' ,'numbers of pyramid levels = 6'})

end

%% blend function 

function blended = blend_rgb(img, example_img, level)
    for i = 1 : 3
        img_chanel = img(:,:,i);
        example_img_chanel = example_img(:,:,i);
        blended_chanel = blend(img_chanel, example_img_chanel, level);
        blended(:,:,i) = blended_chanel;
    end
end

function blended =  blend(img, example_img, level)
    [m,n] = size(img);
    img_mask = zeros(m,n);
    img_mask(:,1:(n/2)) = 1;


    [ img_laplac, ~ ] = create_pyramids( img, level );
    [ example_img_laplac, ~ ] = create_pyramids( example_img, level );
    [ ~, img_mask_gauss ] = create_pyramids( img_mask, level );
    
    for k = 1:length(img_laplac)
        tmp = (img_laplac{k} .* img_mask_gauss{k}) + (example_img_laplac{k} .* abs((1-img_mask_gauss{k})));

        laplac_blend{k} = tmp;
    end

    blended = imRecon(laplac_blend);
end


function [ img ] = imRecon( laplacianPyr )

    for p = length(laplacianPyr)-1:-1:1
        x = laplacianPyr{p};
        y=imresize(laplacianPyr{p+1},'bicubic','OutputSize', size(x));
        laplacianPyr{p} = laplacianPyr{p}+y;
    end

    img = laplacianPyr{1};
end



function [ laplac, gauss ] = create_pyramids( img, level )

    gauss = cell(1,level);
    gauss{1} = im2double(img);
    for p = 2:level
         pyr_blur = imfilter(gauss{p-1}, fspecial('gaussian', 5, 1), 'symmetric');
        gauss{p} =imresize(pyr_blur, 0.5, 'bilinear');
    end

    laplac = cell(1,level);
    for p = 1:level-1
         y= gauss{p};
        x=imresize(gauss{p+1},'bilinear','OutputSize', size(y));
        laplac{p} = gauss{p}-x;
    end
    laplac{level} = gauss{level};

end


