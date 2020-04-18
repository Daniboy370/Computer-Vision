clc; close all; clear all;
set(0, 'defaultfigurecolor', [1 1 1]);

fig_loc = [500 250 800 500]; % NOTE : window opening on 2nd screen(!)
Fig = @() figure('rend', 'painters', 'pos', fig_loc);

% ---------------- Image Loading ---------------- %
addpath([pwd '/training']); addpath([pwd '/test']);
test = double(imread('leaf6.png'));
zscore = zeros(5, 1);

show_contours = 1; % NOTE : set to "0" for canceling plot
for i = 1:6
    if i ~= 6
        % ------- Upload color leaf image ------- %
        training{i} = imread(sprintf('leaf%d.png', i));        
        % --------- Get similarity score--------- %
        score(i) = check_similarity( training{i}, test, show_contours );
    else
        % ------------ control group ------------ %
        score(i) = check_similarity( test, test, show_contours );
    end
end

% ------------ discrete similarity distribution ------------ %
Fig(); stem(score, 'filled', 'MarkerSize', 10); grid on;
ind(1) = xlabel('Image number');
ind(2) = ylabel('Normalized Correlation');
ind(3) = title('Relative correlation');
ax = gca; ax.FontSize = 14;
set(ind, 'Interpreter', 'latex', 'fontsize', 20); clear ind;

