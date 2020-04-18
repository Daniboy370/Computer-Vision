%%
clc; 
clear;
close all;
addpath('sift')

display_image = true;

%% 1.
% Choose a single pair (two consecutive images) for the rest of this work from the folder “building”.

img1_path = './building/building2.JPG';
img2_path = './building/building3.JPG';
img1 = im2double(imread(img1_path));
img2 = im2double(imread(img2_path));


if display_image == true
    figure(1)
    subplot(1,2,1)
    imshow(img1)
    title('Image no.1')
    subplot(1,2,2)
    imshow(img2)
    title('Image no.2')
    suptitle(sprintf('1.\nThe image pair:'))
end


img1 = padarray(img1,[500 500],0,'both');
img2 = padarray(img2,[500 500],0,'both');

%% 2.
% For each image (in the chosen pair), convert to greyscale and extract its SIFT features and descriptors,
% using the function sift.m.

% extract its SIFT features and descriptors:
[frame1, descr1] = sift(rgb2gray(img1));
[frame2, descr2] = sift(rgb2gray(img2));

%   FRAMES is a 4xK matrix storing one SIFT frame per column. 
%   Its format is:
%   FRAMES(1:2,k)  center (X,Y) of the frame k,
%   FRAMES(3,k)    scale SIGMA of the frame k,
%   FRAMES(4,k)    orientation THETA of the frame k.


%% 3.
% Find matching key-points: use the function siftmatch which gets two sets of SIFT descriptors
% (corresponding to two images) and return matching key points. Show all matching key-points on the
% colored images using the function plotmatches.

% find matching key-points:
match12 = siftmatch(descr1, descr2);
matchP1 = frame1(1:2,match12(1,:));
matchP2 = frame2(1:2,match12(2,:));
    
% show all matching key-points on the colored images:
if display_image == true
    figure(2)
    plotmatches(img1,img2, frame1(1:2,:), frame2(1:2,:), match12);
    title(sprintf('3.\nAll the matching key-points:'))
end

%% 4 + 5.

%%-4. 
% Implement a function that gets a set of matching points between two images and calculates the projective
% transformation between them. The transformation should be H3x3 homogenous matrix such each keypoint
% in the first image, p , will map to its corresponding key-points in the second image, p' , according to
% p=H*p' . How many points are needed?

%%-5.
% Find all the inliers: Implement a function that finds the transformation according to all the inliers matches,
% using RANSAC algorithm. At each of the algorithm iteration:
%a. Randomly choose 4 pairs of matching key-points {p, p'} and calculate the projective transformation
%   according to them, such that for each p_i=H*p'_i.
%b. Map all the coordinates from the first image to the second one. calculates the mapping error.
%c. Save the number of inliers in the current iteration: the number of points that have a mapping error of
%   less than 5.
% Repeat for 1000 iterations. Return the transformation H corresponding to the maximal number of inliers
% (remember to re-compute it using all the inliers).
% Show all matching inliers key-points after RANSAC.

% useful functions: imshow, hold on/of, plot, mldivide

[H12, inliers12, match_inliers] = getTransform(frame1(1:2,:), frame2(1:2,:), match12);

% display the matching inliers key-points after RANSAC:
if display_image == true
    figure(3)
    plotmatches(img1,img2, frame1, frame2, match_inliers);
    disp(['Inliers12 = ' num2str(inliers12)]);
    title(sprintf('5.\nmatching inliers key-points after RANSAC:'))
    
    disp(H12);
end

%% 6 + 7.
%Image warping: Implement a function that gets an input image and a projective transformation and returns the projected image. 
% Please note that after the projection there will be coordinates which won’t be integers (e.g sub-pixels), therefor you will need to interpolate between neighboring pixels. For color images, project each color channel separately.
% Note1: You will need to pad the input image appropriately so that the transformed image will not get cropped at the edges. The padding doesn’t have to be exact, just add enough so that the entire warped image is visible.
% Note2: imwarp() is not allowed. You need to write your own implementation of warping.
% Useful functions: interp2 

warped_img1 = imageWarping(img1, H12);
if display_image == true
    figure(4)
    imshow(warped_img1);
    title(sprintf('6+7.\nImage warping:'))
end



%% 8. 
% Stitching: Implement a function that gets two images after alignment and returns a union of the two. 
% The union should be a simple overlay of one image on the other. Leave empty pixels painted black.

stiched_img = imageStiching(warped_img1, img2);
if display_image == true
    figure(5)
    imshow(stiched_img);
    title(sprintf('9.\nImage stitching:'))
end



