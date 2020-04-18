clc; clear; close all;
% input image:
% addpath(genpath('data'));
imgPath = '../data/Inputs/imgs/0004_6.png';
img = double(imread(imgPath))/255;

% input image mask:
img_mask_Path = '../data/Inputs/masks/0004_6.png';
img_mask = double(imread(img_mask_Path))/255;
%imshow(img_mask)

% example image:
exampleImgPath = '../data/Examples/imgs/6.png';
example_img = double(imread(exampleImgPath))/255;
% imshow(example_img)

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/6.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;
% imshow(example_img_background)

nLevel = 6;


%% 3-a:     create laplacian pyramid
lap_pyramid = laplacian_pyramid(rgb2gray(img), nLevel);

figure(1)
for i = 1 : length(lap_pyramid)
    subplot(1,length(lap_pyramid),i);
    imshow(lap_pyramid{i});
    title("L_l["+num2str(i)+"]")
end
sgtitle("ex3-a: laplacian pyramid")

% figure()
% montage(lap_pyramid, 'size', size(lap_pyramid),'DisplayRange', [])
% title("ex3-a: laplacian pyramid")

%% 3-b:     reconstruct laplacian pyramid

rec_image = reconstruct_laplacian_pyramid(lap_pyramid);

figure(2);
subplot(1,2,1);
imshow(rgb2gray(img),[]);
title("original image")
subplot(1,2,2); 
imshow(rec_image,[]);
title("reconstructed image")
sgtitle("ex3-b: original image VS reconstructed image")


%% 3-c:     changing backgroung to the example's image background

img_with_background = (img.*img_mask) + example_img_background.*(1-img_mask);
figure(3);
subplot(1,2,1);
imshow(img,[]);
title("Input image with Original Background")
subplot(1,2,2); 
imshow(img_with_background,[]);
title("Input image with Example Background")
sgtitle("ex3-c: change background")

%% 3-d:     Calculate the energy and the Gain

r_gain = compute_gain_one_chanel(img_with_background(:,:,1), example_img(:,:,1), nLevel-1);
g_gain = compute_gain_one_chanel(img_with_background(:,:,2), example_img(:,:,2), nLevel-1);
b_gain = compute_gain_one_chanel(img_with_background(:,:,3), example_img(:,:,3), nLevel-1);


%% 3-e:     Construct the output image pyramid

[r_output_img_pyramid, g_output_img_pyramid, b_output_img_pyramid] = construct_output_image_pyramid(img_with_background,example_img, nLevel);

%% 3-f:     Reconstruct the output image

% reconstruct and fuse the rgb chanels
rec_image = zeros( size(example_img) );
rec_image(:,:,1) = reconstruct_laplacian_pyramid(r_output_img_pyramid);
rec_image(:,:,2) = reconstruct_laplacian_pyramid(g_output_img_pyramid);
rec_image(:,:,3) = reconstruct_laplacian_pyramid(b_output_img_pyramid);

%replace background:
output_img = (rec_image.*img_mask) + example_img_background.*(1-img_mask);

%display the output image
figure(4);
subplot(1,3,1);
imshow(img,[]);
title("Input image")
subplot(1,3,2);
imshow(example_img,[]);
title("Example image")
subplot(1,3,3); 
imshow(output_img,[]);
title("Output image")
sgtitle("ex3-f")


%% 3-g:     apply style transfer for varias of images:

% transferring the style of images 16 & 21 to the input image 0004_6.png
%-----------------------------------------------------------------------
% input image:
imgPath = '../data/Inputs/imgs/0004_6.png';
img = double(imread(imgPath))/255;

% input image mask:
img_mask_Path = '../data/Inputs/masks/0004_6.png';
img_mask = double(imread(img_mask_Path))/255;

% example image:
exampleImgPath = '../data/Examples/imgs/16.png';
example_img = double(imread(exampleImgPath))/255;
%imshow(example_img,[]);

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/16.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;


figure_num = 16;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);


% example image:
exampleImgPath = '../data/Examples/imgs/21.png';
example_img = double(imread(exampleImgPath))/255;

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/21.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;

figure_num = 21;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);

% transferring the style of images 0,9,10  to the input image 0006_001.png
%-----------------------------------------------------------------------

% input image:
imgPath = '../data/Inputs/imgs/0006_001.png';
img = double(imread(imgPath))/255;

% input image mask:
img_mask_Path = '../data/Inputs/masks/0006_001.png';
img_mask = double(imread(img_mask_Path))/255;

% example image:
exampleImgPath = '../data/Examples/imgs/0.png';
example_img = double(imread(exampleImgPath))/255;
%imshow(example_img,[]);

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/0.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;


figure_num = 99;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);

% example image:
exampleImgPath = '../data/Examples/imgs/9.png';
example_img = double(imread(exampleImgPath))/255;
%imshow(example_img)

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/9.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;

figure_num = 9;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);

% example image:
exampleImgPath = '../data/Examples/imgs/10.png';
example_img = double(imread(exampleImgPath))/255;


% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/10.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;

figure_num = 10;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);


%% 3-h:     apply style transfer on other input image

% example image:
exampleImgPath = '../data/Examples/imgs/10.png';
example_img = double(imread(exampleImgPath))/255;

%my image
my_image_path = "my_no_background.png";
my_image = double(imread(my_image_path))/255;
image_size = size(example_img);
img = imresize(my_image,image_size(1:2));
%imshow(img)

img_mask = zeros(image_size);
my_mask = double(rgb2gray(my_image)<1);
my_mask = imresize(my_mask,image_size(1:2));
se = strel('disk',4);
mask_one_chanel = imdilate(my_mask,se);
mask_one_chanel = imerode(mask_one_chanel,se);
mask_one_chanel = imerode(mask_one_chanel,se);

mask_one_chanel=mask_one_chanel;


img_mask(:,:,1) = mask_one_chanel;
img_mask(:,:,2) = mask_one_chanel;
img_mask(:,:,3) = mask_one_chanel;
%imshow(img_mask)


% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/9.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;


nLevel = 6;

figure_num = 69;
style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);

%% 3-i:     apply style transfer with diffrent number of levels

% input image:
imgPath = '../data/Inputs/imgs/0004_6.png';
img = double(imread(imgPath))/255;

% input image mask:
img_mask_Path = '../data/Inputs/masks/0004_6.png';
img_mask = double(imread(img_mask_Path))/255;

% example image:
exampleImgPath = '../data/Examples/imgs/6.png';
example_img = double(imread(exampleImgPath))/255;
%imshow(example_img,[]);

% example image background:
exampleImg_backgrpund_Path = '../data/Examples/bgs/6.jpg';
example_img_background = double(imread(exampleImg_backgrpund_Path))/255;



figure_num = 16;
nLevel = 6;
output_img = style_transfer(img ,img_mask, example_img, example_img_background, nLevel, figure_num);

%replace background:
img = (img.*img_mask) + example_img_background.*(1-img_mask);

pyramid_blendingg(img, output_img)

