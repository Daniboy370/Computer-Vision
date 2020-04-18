set(0, 'defaultfigurecolor', [1 1 1]);
clc; close all; clear;
fig_loc = [500 250 800 500]; % NOTE : window opening on 2nd screen(!)
Fig = @() figure('rend', 'painters', 'pos', fig_loc);


% Write a Matlab code which preforms line fitting to the following measured points:
xi = [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10]'- 0.5 + randn(20,1);
yi = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9]' - 0.5 + randn(20,1) + 5;

% ----------------- Least Squares ----------------- %
A = [xi ones(20, 1)];
LS_poly = pinv(A)*yi;               % <=> (A'*A)^(-1)*A'*yi <=> A \ yi;
x_l = linspace(-2, 12);

% -------------- Total Least Squares -------------- %
A_tot = [xi + mean(xi) yi + mean(yi)];          % s.t. E = sum{ ax_i + by_i + c }
[U, S, V] = svd(A_tot'*A_tot);                  % Using SVD decomposition
TLS_poly = V(:, end);                           % = smallest singular vector

% ---- Plot the LS and TLS fitting on the same graph ---- %
    % LS
Fig(); grid on; hold on;
f_LS  = @(x, p) p(1)*x.^1 + p(2)*x.^0;          % f(x) = a*x + b*(1)
    % TLS
[a, b] = deal( TLS_poly(2), TLS_poly(1) );
c = -a*mean(xi) -b*mean(yi);                    % y-interception
f_TLS = @(x) -(a/b)*x.^1 - (c/b);               % b*y_i = -a*x_i - c ;

plot( x_l, f_LS(x_l,  LS_poly), '--', 'LineWidth', 2.5);
plot( x_l, f_TLS(x_l), '--', 'LineWidth', 2.5);
scatter(xi, yi, 40, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor', [0 .7 .7], 'LineWidth',1.5);
ind(1) = xlabel('$x_i$');
ind(2) = ylabel('$y_i$');
ind(3) = title('x-y Line fitting');
ind(4) = legend('LS', 'TLS', 'location', 'northwest');
set(ind, 'Interpreter', 'latex', 'fontsize', 18); clear ind;
