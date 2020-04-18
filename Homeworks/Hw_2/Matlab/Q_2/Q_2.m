set(0, 'defaultfigurecolor', [1 1 1]);

clc; close all; clear;
fig_loc = [500 250 800 500]; % NOTE : window opening on 2nd screen(!)

Fig = @() figure('rend', 'painters', 'pos', fig_loc);

%% a. Explain the result of each imshow as it appears on the Hough domain :

Fig();
f=zeros(101, 101); H=hough(f);
subplot(2, 3, 1); imshow(H,[]); ind(1) = title('f(:, :)=0');
f(1,1)=1;       H=hough(f);
subplot(2, 3, 2); imshow(H,[]); ind(2) = title('f(1, 1)=1');
f(101, 1)=1;    H=hough(f);
subplot(2, 3, 3); imshow(H,[]); ind(3) = title('f(101, 1)=1');
f(1, 101)=1;    H=hough(f);
subplot(2, 3, 4); imshow(H,[]); ind(4) = title('f(1, 101)=1');
f(101, 101)=1;  H=hough(f);
subplot(2, 3, 5); imshow(H,[]); ind(5) = title('f(101, 101)=1');
f(51, 51)=1;    H=hough(f);
subplot(2, 3, 6); imshow(H,[]); ind(6) = title('f(51, 51)=1');

set(ind, 'Interpreter', 'latex', 'fontsize', 14); clear ind;


for i = 1:2        % 1 == binary square  2 == building image
    pause(2); clear Img;
    if (i == 1)
        % b. Generate a binary image of a square :
        sz = 100; Img = zeros(sz); sq_r = 1/5;
        % ------------- Square Geometry ------------- %
        Img( sz*sq_r:sz*(1-sq_r), sz*sq_r ) = 1;          % left  side
        Img( sz*sq_r:sz*(1-sq_r), sz*(1-sq_r) ) = 1;      % right side
        Img( sz*sq_r,   sz*sq_r:sz*(1-sq_r)  ) = 1;       % upper side
        Img( sz*(1-sq_r), sz*sq_r:sz*(1-sq_r) ) = 1;      % down  side
        
        Fig(); imshow( Img ); title('Square');            % W/B
        [CE_Threshold, num_peaks] = deal(0.125, 4);       % HT parameters
    else    % ------------ Building image ----------- %
        Img = im2double( imread('building.jpg') );
        [CE_Threshold, num_peaks] = deal(0.10, 100);     % HT parameters
    end
    
    % c. Use the canny edge detection to generate an image of the square's edges :
    Img_edge = edge(Img, 'canny', CE_Threshold);
    Fig(); imshow(Img_edge, []);  title('Canny Edge Detection');
    
    % d. Display the Hough transform of the image, and explain the results
    [H, T, R] = hough(Img);
    Fig(); imshow(H,[],'XData',T,'YData',R, 'InitialMagnification','fit');
    ind(1) = xlabel('$-90 \leq \theta < 90$');
    ind(2) = ylabel('$r$');
    ind(3) = title('Parameter (Hough) space');
    set(ind, 'Interpreter', 'latex', 'fontsize', 16); clear ind;
    axis on, axis normal, hold on;
    
    % f. Use the function houghpeaks on the Hough transform of the square.
    max_votes = houghpeaks(H, num_peaks);
    P = houghpeaks(H, num_peaks, 'threshold', ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    plot(x, y, 's', 'color', 'white');
    
    % g. Use the function houghlines and plot the detected lines over the square image
    if ( i == 1 )
        Img_edge = Img;
    end
    lines = houghlines(Img_edge, T, R, P, 'FillGap', 5, 'MinLength', 7);
    pause(1); Fig(); imshow(Img); hold on;
    max_len = 0;
    
    % ------ Project repective lines on original image ----- %
    for k = 1:length(lines)
        % ------ Plot lines using objects properties ------- %
        x_y = [lines(k).point1; lines(k).point2];
        plot(x_y(:,1),x_y(:,2),'LineWidth',2,'Color','green');
        
        % --------------- Plot line's edges ---------------- %
        plot(x_y(1,1),x_y(1,2), 'o', 'LineWidth', 1.5, 'Color', 'yellow');
        plot(x_y(2,1),x_y(2,2), 'o', 'LineWidth', 1.5, 'Color', 'red');
        
        % --------- Denote each endpoints of lines --------- %
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
            max_len = len; xy_long = x_y;
        end
    end
    title(['Detected Edges by Hough transform (', num2str(num_peaks), ' peaks)']);
end
