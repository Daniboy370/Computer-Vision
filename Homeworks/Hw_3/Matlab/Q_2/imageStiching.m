function stichedImg = imageStiching(img1_warped, img2)

    % replece pixels with pixels from warped image
    stichedImg = img2;
    stichedImg(img1_warped > 0 & img2 == 0) = img1_warped(img1_warped > 0 & img2 == 0);
    
    % remove redundant zero padding
    [row,col] = find( stichedImg(:,:,1) ~= 0 ); 
    stichedImg = stichedImg( min(row(:)):max(row(:)),min(col(:)):max(col(:)),: );
end