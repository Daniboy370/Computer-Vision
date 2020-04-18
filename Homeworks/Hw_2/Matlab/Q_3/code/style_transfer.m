function output_img = style_transfer (img ,img_mask, example_img, example_img_background, nLevel, figure_num)
    %change original image backgroung:
    img_with_background = (img.*img_mask) + example_img_background.*(1-img_mask);
    
    %construct output image pyramid:
    [r_output_img_pyramid, g_output_img_pyramid, b_output_img_pyramid] = construct_output_image_pyramid(img_with_background,example_img, nLevel);

    % reconstruct and fuse the rgb chanels
    rec_image = zeros( size(example_img) );
    rec_image(:,:,1) = reconstruct_laplacian_pyramid(r_output_img_pyramid);
    rec_image(:,:,2) = reconstruct_laplacian_pyramid(g_output_img_pyramid);
    rec_image(:,:,3) = reconstruct_laplacian_pyramid(b_output_img_pyramid);

    %replace background:
    output_img = (rec_image.*img_mask) + example_img_background.*(1-img_mask);

    %display the output image
    figure(figure_num);
    subplot(1,3,1);
    imshow(img,[]);
    title("Input image")
    subplot(1,3,2);
    imshow(example_img,[]);
    title("Example image")
    subplot(1,3,3); 
    imshow(output_img,[]);
    title("Output image")
    %suptitle("ex3-f")
    hold on;

end

