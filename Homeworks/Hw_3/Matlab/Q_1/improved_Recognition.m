function test_label = improved_Recognition(X_trn_subt, X_tst_subt, W_trn, train_face_id)

num_test_imgs   = size(X_tst_subt,  2);
X_test_Proj     = X_tst_subt * W_trn(1:num_test_imgs, :) * W_trn(1:num_test_imgs, :)';
X_train_Proj    = X_trn_subt * W_trn * W_trn';
num_train_imgs  = size(X_train_Proj, 2);

test_label      = zeros(1, num_test_imgs);
delta_face      = zeros(num_train_imgs, 1);

for i = 1 : num_test_imgs
    for j = 1:num_train_imgs
        delta_face(i, j) =  norm( X_test_Proj(:, i) - X_train_Proj(:, j)  );
    end
    [~, min_train_image] = min( delta_face(i, :) );
    test_label(1, i) = train_face_id(min_train_image);
end

%% uncomment for presenting the difference :
% close all; k = 4;
% figure; imshow( reshape( X_test_Proj(:, k), [243 320] ), [] );
% figure; imshow( reshape( X_train_Proj(:, 60), [243 320] ), [] )

