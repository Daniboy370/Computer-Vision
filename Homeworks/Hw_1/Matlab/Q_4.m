set(0, 'defaultfigurecolor', [1 1 1]);

clc; close all; clear all;
fig_loc = [500 250 800 500]; % NOTE : window opening on 2nd screen(!)

Fig = @() figure('rend', 'painters', 'pos', fig_loc);

% load and draw image
im = imread('goal_picture.jpg');
Fig(); clf; image(im);

%% a. Compute the camera matrix M which generated the image points x

% 2d points (x, y, w) in the image :
Pts2d = 1e3*[
    1.6610 1.4366 1.4323 1.6698 1.8765 0.9660 0.5745 1.2783 NaN NaN NaN 1.0320
    0.9818 0.7637 0.4274 0.6122 1.1961 1.2146 0.6343 0.6270 NaN NaN NaN 0.3978
    0.0010 0.0010 0.0010 0.0010 0.0010 0.0010 0.0010 0.0010 NaN NaN NaN 0.0010 ];

hold on; grid on;
for i = 1:length(Pts2d)
    plot(Pts2d(1, i), Pts2d(2, i), 'bo', 'linewidth', 8);
    plot(Pts2d(1, i), Pts2d(2, i), 'ro', 'linewidth', 5);
    text(Pts2d(1, i), Pts2d(2, i), num2str(i), 'color', 'w', 'FontSize', 28);
end

Fig();
X = field_geometry;

x = Pts2d( :, all( ~isnan(Pts2d) ) );           % Extract valid (in-frame) points
n_dim = length(x);                              % Optional :: reduce number of points
m = DLT(X, x, n_dim);                           % Singular Values of M
M = reshape(m, 4, 3)';                          % Reshape into desired dimensions

%% b. Re-project all the real world point X to their estimated corresponded points x on the image

x_est = zeros(3, n_dim); hold on;

% Projection of real points onto image, using estimated M
for i = 1:length(X)
    x_est(:, i) = M * X(:, i);
end

% Extract pixels (divide by w_est)
pxl_est = [ x_est(1, :)./x_est(3, :); x_est(2, :)./x_est(3, :) ];

% Project on 1st figure for comparison
figure(1);
plot( pxl_est(1, :), pxl_est(2, :), 'gp', 'linewidth', 2); grid on;

[du, dv] = deal( pxl_est(1, :) - x(1, :), pxl_est(2, :) - x(2, :) );
f_RMSE = @(x) sqrt( mean( x ));
err_MAE = [mean( abs(du)), mean( abs(dv))];      % Mean absolute error [px]
err_RMSE = [f_RMSE( du.^2 ), f_RMSE( dv.^2 )];	 % Root Mean Squear    [px]
err_rel = abs( [du/x(1,:), dv/x(2,:)])*100;      % Relative Error      [--]

%% c. d. Use the given function “rq.m” to reconstruct R , K .

[K1, R1] = rq( M(:, 1:3) );                      % QR factorization
[R2, K2] = qr( M(:, 1:3)' );                     % QR factorization

%% e. What can you say about the orientation of the camera from the matrix R ?
[K, R, M] = deal(K1/K1(3, 3) , R1, M/K1(3, 3) )
eulXYZ = rad2deg( rotm2eul( R, 'xyz' ) );        % [roll, pitch, yaw]

%% f. Compute the translation vector.

t = K^(-1)*M(:, 4);                              % translation vector
X_0 = -(K*R)^(-1)*M(:, 4);                       % <=> -R'*t ( X_0 = -R'*t )

%% g. Plot the camera location onto the given 3D field model.
Fig(); [~] = field_geometry;
scatter3( X_0(1), X_0(2), X_0(3), 'kp', 'linewidth', 2);
xlim([-70 20.16]); ylim([0 20]); zlim([0 20]); view([-111 10]);
title('Camera location'); hold on;


unit_vec = 0:.25:3; O_lin = zeros(1, length(unit_vec));
S(:, 1) = [unit_vec O_lin      O_lin];
S(:, 2) = [O_lin    unit_vec   O_lin];
S(:, 3) = [O_lin    O_lin   unit_vec];

for i = 1:length(S)
    cam_vec = ([-R' X_0]*[S(i, :) 1]');
    if i <= length(unit_vec)
        plot3( cam_vec(1), cam_vec(2), cam_vec(3), 'r.', 'linewidth', 2);
    elseif i <= length(unit_vec)*2
        plot3( cam_vec(1), cam_vec(2), cam_vec(3), 'b.', 'linewidth', 2);
    else
        plot3( cam_vec(1), cam_vec(2), cam_vec(3), 'g.', 'linewidth', 2);
    end
end

%% h. can you determine if the ball actually crossed the goal line? ('y_ball < 0' == goal )

% We can extract the intersection line of 2 planes obtained :

[u_ball, v_ball] = deal(1581, 674);         % pin the ball left-most point

% ---------- Obtain planes by homog. Eq. ---------- %
P_1 = [M(1, 1:3)-M(3, 1:3)*u_ball , M(1, 4)-u_ball*M(3, 4)]; P_1 = P_1/P_1(3);
P_2 = [M(2, 1:3)-M(3, 1:3)*v_ball , M(2, 4)-v_ball*M(3, 4)]; P_2 = P_2/P_2(3);

xy_line = P_2 - P_1; xy_line = xy_line/xy_line(2) % y = -0.2336 x - 0.2711

% y = @(x) -0.2336 * x - 0.2711         % <-- express as function handle