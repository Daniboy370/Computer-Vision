function train_represent_error( X_Data, x_mn, x_plot )

% if full_rank
n_tot = rank( X_Data );
X_trn_subt = X_Data - x_mn;

RMSE_err = zeros(n_tot, 1);

for r = 1 : n_tot
    W_r = get_EigenFace( X_trn_subt, r );           % W -- eigenfaces
    Y_r = X_trn_subt * W_r;                         % 25 eigenvectors basis
    X_r = x_mn + Y_r * W_r';                        % reconstructed images
    
    RMSE_err(r) = RMSE_func( X_r, X_Data );         % RMSE calculation
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
