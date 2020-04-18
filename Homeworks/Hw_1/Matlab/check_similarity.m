function score = check_similarity(train, test, show_contours)
% ----------------------- Description ----------------------- %
%                                                             %
%      Compute similarity of two matrces by calculating       %
%      their Normalized Cross-Correlation (NCC) measure
%                                                             %
% ------------------------- Content ------------------------- %

% ----- Binarize matrices and turn shape white on black ----- %
train_BW = double(img_binarize( train ));
test_BW  = double(img_binarize( test  ));

% --------------- Centralize and fit matrices --------------- %
train_BW = img_centralize_shape( train_BW );
test_BW  = img_centralize_shape(  test_BW );

% ---------------- Extract contours using SE ---------------- %
train_contour = img_edge_detection( train_BW );
test_contour  = img_edge_detection(  test_BW );

if (show_contours)
    figure; imshow( 1 - train_contour );      % (!) for illustration only (!)
    pause(1.5);
end

% -------- Extract object's edges using dilation -------- %
    function img_BW = img_binarize( img )
        % ---- using threshold operator ---- %
        thresh = 165;
        img_BW = double(img(:, :, 3) < thresh );
    end

% -------- Extract object's edges using dilation -------- %
    function img_contour = img_edge_detection( img )
        % ------- using dilation SE ------- %
        n_dim = 6; Ker = ones(n_dim)/n_dim^2;
        C_same = conv2(img, Ker, 'same');
        img_contour = abs( C_same - img );
    end

% ---------- impose matrix inside bigger frame ---------- %
    function mat = img_centralize_shape( img )
        mat = zeros(250);        % global black background
        [sz_mat, sz_img] = deal( size(mat), size(img) );
        mid = floor((sz_mat - sz_img)/2)+1;
        mat(mid(1)+(0:sz_img(1)-1), mid(2)+(0:sz_img(2)-1)) = img;
    end

% ------ Calculate Normalized Cross-Correlation (NCC) ------- %
[N, x1, x2] = deal( numel( train_BW ), train_BW(:), test_BW(:) );
% score = xcorr( x1, x2, 0, 'normalized');      % <==> Matlab IP toolbox
score = (1/N)*( (x1-mean(x1))'*(x2-mean(x2)) )/sqrt( var(x1)*var(x2) );
end