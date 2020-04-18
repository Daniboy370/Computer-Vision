function W = get_EigenFace( A_subtract, r )

C_t = A_subtract'*A_subtract;

% --------- using SVD --------- %
[~, SV, Eig_vec_svd] = svd( C_t );

if contains('max', num2str(r) )
    r = rank(SV);
end

W = Eig_vec_svd( :, 1:r );  % low-dimension basis