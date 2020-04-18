function warped_img1 = imageWarping(img1, H12)

    % create a vector of all the img1 coordinates 
    [rows_num, col_num, ~] = size(img1);
    [x_mesh, y_mesh] = meshgrid(1:col_num, 1:rows_num);
    img1_cordinates = [ x_mesh(:) y_mesh(:) ones(length(x_mesh(:)),1)]';

    % transform img1 cordinates to img2 coordinates system 
    img1_cordinates_projected = H12\img1_cordinates;
    img1_cordinates_projected = img1_cordinates_projected./img1_cordinates_projected(3,:);
    xq = reshape(img1_cordinates_projected(1,:), rows_num, col_num);
    yq = reshape(img1_cordinates_projected(2,:), rows_num, col_num);

    % interpolate pixel values
    img1(:,:,1) = interp2(x_mesh, y_mesh, img1(:,:,1), xq, yq);
    img1(:,:,2) = interp2(x_mesh, y_mesh, img1(:,:,2), xq, yq);
    img1(:,:,3) = interp2(x_mesh, y_mesh, img1(:,:,3), xq, yq);
    
    warped_img1 = img1;
end