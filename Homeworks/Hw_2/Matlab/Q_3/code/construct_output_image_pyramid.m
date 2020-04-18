function [r_output_img_pyramid, g_output_img_pyramid, b_output_img_pyramid] = construct_rgb_output_image_pyramid(img_with_background, example_img, nLevel)

    r_output_img_pyramid = construct_one_chanel_output_image_pyramid(img_with_background(:,:,1), example_img(:,:,1), nLevel);
    g_output_img_pyramid = construct_one_chanel_output_image_pyramid(img_with_background(:,:,2), example_img(:,:,2), nLevel);
    b_output_img_pyramid = construct_one_chanel_output_image_pyramid(img_with_background(:,:,3), example_img(:,:,3), nLevel);

end

function [chanels_output_img_pyramid] = construct_one_chanel_output_image_pyramid(img_chanel, example_img_chanel, nLevel)
    % compute laplacian pyramids:
    img_pyramid = laplacian_pyramid(img_chanel, nLevel);
    example_img_pyramid = laplacian_pyramid(example_img_chanel, nLevel);
    
    if nLevel > 1
        % compute gain pyramid:
        gain = compute_gain_one_chanel(img_chanel, example_img_chanel, nLevel-1);

        % construct the chanels output image pyramid:
        chanels_output_img_pyramid = cell(nLevel,1);
        for i = 1 : nLevel-1
          chanels_output_img_pyramid{i} = gain{i} .* img_pyramid{i};
        end
    end
    
    chanels_output_img_pyramid{nLevel} = example_img_pyramid{nLevel};
    
end
