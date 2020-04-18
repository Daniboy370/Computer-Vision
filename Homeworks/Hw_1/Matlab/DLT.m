function eig_val = DLT(X_in, x, n_dim)
% ----------------------- Description ----------------------- %
%                                                             %
%                   Compute camera matrix M                   %
%                   return : Singular Value matrix            %
%                                                             %
% ------------------------- Content ------------------------- %

A = zeros(2*n_dim, 12);
O = zeros(4, 1);

for i = 1:n_dim
    [X, u, v] = deal( X_in(:, i), x(1 , i), x(2, i) );
    A( 2*i-1:2*i, :) = [ [-X' O' u*X']; [O' -X' v*X'] ];
end

[~, ~, V] = svd(A);
eig_val = V(:, end);        % extract right-most column