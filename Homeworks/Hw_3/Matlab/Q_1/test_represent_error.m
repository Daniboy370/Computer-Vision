function test_represent_error( X_test_tr, X_train, x_plot )

% if full_rank
% n_tot = rank( X_train );

n_tot = size( X_test_tr, 2);
RMSE_err = zeros( n_tot, 1);
x_trn_mean = mean( X_train, 2);
X_tst_subt = double( X_test_tr ) - x_trn_mean;

for r = 1 : rank( X_train )
    W = get_EigenFace( X_train, r );    % W - eigenfaces
    W_r = W(1:n_tot, :);
    Y_r = X_tst_subt * W_r;             % r - eigenvectors basis
    X_r = x_trn_mean + Y_r * W_r';      % reconstructed images
    
    RMSE_err(r) = RMSE_func( X_r(:, 1:n_tot), X_test_tr );    % RMSE calculation
end

% --------------------------------------------------- %
figure('rend', 'painters', 'pos', [300 250 800 500]);

if contains(x_plot, 'log')
    semilogy(1:r, RMSE_err, '-o', 'LineWidth', 1.25); grid on;
else
    plot(1:r, RMSE_err, '-o', 'LineWidth', 1.25); grid on;
end

ind(1) = xlabel('r-dimension');
ind(2) = ylabel('$ ( \Delta \, err / N) / {255}$ \, [$\%$]');
ind(3) = title('Average Representation Error vs. r');
ax = gca; ax.FontSize = 14;
set(ind, 'Interpreter', 'latex', 'fontsize', 19); clear ind;
