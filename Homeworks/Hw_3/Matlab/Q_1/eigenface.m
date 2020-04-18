set(0, 'defaultfigurecolor', [1 1 1]);
clc; close all; clear;
fig_loc = [300 250 800 500]; % NOTE : window opening on 2nd screen(!)
Fig = @() figure('rend', 'painters', 'pos', fig_loc);
addpath( genpath(pwd) );

% load train set (1.a)
readYaleFaces; img_size = [m n];

%% -------- function handles -------- %
vec_2_img = @(x) reshape( x, img_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Your Code Here                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subtract mean image (1.b)
img_num  = size( X_train, 2);
x_trn_mean = mean( X_train, 2);
X_trn_subt = double( X_train ) - x_trn_mean;

Fig(); imshow( vec_2_img( x_trn_mean ), [] );
title('Training set mean face', 'FontSize', 16, 'FontName', 'Amiri');

% Compute eigenvectors and report first 5 eigen-faces (2)
r = 5;
W_trn_5 = get_EigenFace( X_trn_subt, r );              % W -- get_EigenFaces
Y_trn_5 = X_trn_subt * W_trn_5;                   % 25 eigenvectors basis
plot_5_img( Y_trn_5, img_size, '5 eigenfaces of train images' );

% Display and compute the representation error for the training images (3)
r = 25;
W_trn_25 = get_EigenFace( X_trn_subt, r );          % W -- get_EigenFaces
Y_trn_25 = X_trn_subt * W_trn_25;                   % 25 eigenvectors basis
X_trn_25 = x_trn_mean + Y_trn_25 * W_trn_25';       % reconstructed images

RMSE_err = RMSE_func( X_train, X_trn_25 );          % RMSE calculation
disp(['Representation error of training set (r=25) : ' num2str(RMSE_err) ' [%]']);

plot_5_img( X_train , img_size, 'Original Images' );
plot_5_img( Y_trn_25, img_size, '5 eigenfaces of train images' );
plot_5_img( X_trn_25, img_size, 'Reconstructed train images (r=25)' );

% Fig(); imshow( vec_2_img( X_trn_25(:, 10)), [] ); % demonstration of low-dim.

train_represent_error( X_train, x_trn_mean, 'reg' )

% Compute the representation error for the test images.
% 4. build a r-25 representation vector of test images

valid_idx = ( face_id ~= 0 ) & ( face_id ~= -1);
test_label = face_id(valid_idx);
Face_loc = find( valid_idx );
X_test = X_test(:, Face_loc);                   % extract trained samples
test_valid = length(Face_loc);

num_valid_tests = size( X_test, 2);
X_tst_subt = double( X_test ) - x_trn_mean ;

W_tst_25 = W_trn_25(1:num_valid_tests, :);
Y_tst_25 = X_tst_subt * W_tst_25;               % 25 eigenvectors basis
X_tst_25 = x_trn_mean + Y_tst_25 * W_trn_25';

RMSE_err = RMSE_func( X_tst_25(:, 1:num_valid_tests), X_test );
disp(['Representation error of test     set (r=25) : ' num2str(RMSE_err) ' [%]']);

plot_5_img( X_test, img_size,    'Original test Images' );
plot_5_img( X_tst_25,  img_size, 'Reconstructed test images (r=25)' );

test_represent_error( X_test, X_trn_subt, 'reg' );


%% Classify the test images and report error rate (4)
fprintf('\nKnn model : \n');
for k_nn = 1:30
    Model = fitcknn(X_train', train_face_id', 'NumNeighbors', k_nn, 'Standardize', 1);
    Label_temp = predict( Model, X_test' )';
    Accuracy(k_nn) = sum( Label_temp ~= test_label )/num_valid_tests;
    disp([' KNN = ' num2str(k_nn) ' - success ratio : ' num2str(1-Accuracy(k_nn))]);
end

%%
figure('rend', 'painters', 'pos', [500 250 800 500]);
grid on; hold on;
plot(1:k_nn, Accuracy, '--o', 'LineWidth', 1.25);
scatter(1:k_nn, Accuracy, 35, 'r', 'filled');
ind(1) = xlabel('K-nearest neighbours');
% ind(2) = ylabel('$f(X_{test}) / Y_{test}$ [$\%$]');
ind(2) = ylabel('Misclassification Error');
ind(3) = title('Model accuracy vs. K-NN');
ax = gca; ax.FontSize = 12;
set(ind, 'Interpreter', 'latex', 'fontsize', 19); clear ind;

Fig(); sgtitle('misclassified images', 'FontSize', 26, 'FontName', 'Amiri');
subplot(1, 2, 1); imshow( vec_2_img( X_test(:, 4) ), [] )
subplot(1, 2, 2); imshow( vec_2_img( X_test(:, 7) ), [] )

%% Improved recognition algorithm :

X_tst_subt = double( X_test ) - mean(X_test, 2) ;
max_rank = size( X_train, 2);
W_trn_max = get_EigenFace( X_trn_subt, max_rank );     
Recognize_test_label = improved_Recognition(X_trn_subt, X_tst_subt, W_trn_max, train_face_id);

Accuracy_new = sum( Recognize_test_label == test_label )/num_valid_tests;
fprintf(['\n' 'Improved success ratio : ' num2str(Accuracy_new) '\n']);

%%
Fig(); sgtitle('Preprocessed test images', 'FontSize', 20, 'FontName', 'Amiri');
for i = 1:11
    subplot(3, 4, i); imshow( vec_2_img( X_tst_subt(:, i) ), [] )
end

