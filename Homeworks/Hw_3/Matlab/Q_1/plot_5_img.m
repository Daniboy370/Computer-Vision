function plot_5_img( Data, img_size, str )
figure('rend', 'painters', 'pos', [500 250 800 500]);

% str = '5 largest eigenfaces';
sgtitle(str, 'FontSize', 22, 'FontName', 'Amiri');

for i = 1:5
    img =  reshape( Data(:, i), img_size )';
    subplot(2, 3, i); imshow(img', []);
end

