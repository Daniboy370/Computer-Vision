function [H, inliers_max_num, match_inliers] = getTransform(P1, P2, match)
    ITERATIONS_NUM = 1000;
    TH = 5;
    
    inliers_max_num = 0;
    matchP1 = P1(: ,match(1,:));
    matchP2 = P2(: ,match(2,:));
    for iteration = 1:ITERATIONS_NUM
        % randomly choose 4 pairs of matching key-points:
        rnd = randi([1 size(match,2)],1,4);
        keyIndex = match(:,rnd);
        p1Index = keyIndex(1,:);
        p2Index = keyIndex(2,:);
        p1_selected = P1(:,p1Index);
        p2_selected = P2(:,p2Index);
        % calculate projective transformation:
        H = getProjectiveTransform(p1_selected, p2_selected);
        % Map all the coordinates from the first image to the second one
        P1_projected_unnormalized = H * [matchP1; ones(1,length(matchP1))];
        P1_projected = P1_projected_unnormalized(1:2,:)./P1_projected_unnormalized(3,:);
        % calculates the mapping error:
        mapping_err = sqrt(sum((matchP2-P1_projected).^2,1)); 
        % Save the number of inliers in the current iteration:
        curr_inliers_num = sum(mapping_err < TH);
        if curr_inliers_num > inliers_max_num
            inliers_max_num = curr_inliers_num;
            matches_inliers = match(:,mapping_err<TH);
        end
    end

    % Recompute the transformation (including all the inliers)
    matchP1_inliers = P1(: ,matches_inliers(1,:));
    matchP2_inliers = P2(: ,matches_inliers(2,:));    
    H = getProjectiveTransform(matchP1_inliers, matchP2_inliers);
    
    % find matching inlier key-points (after ransac)
    P1_projected_unnormalized = H*[matchP1;ones(1,length(matchP1))];
    P1_projected = P1_projected_unnormalized(1:2,:)./P1_projected_unnormalized(3,:);
    mapping_err = sqrt(sum((matchP2-P1_projected).^2,1));
    match_inliers = match(:,mapping_err<TH);
end


function H = getProjectiveTransform(p1, p2)
    
    x1 = [p1' ones(size(p1',1),1)]';
    x2 = [p2' ones(size(p1',1),1)]';
    Npts = length(x1);
    A = zeros(2*Npts,9);
    
    O = [0 0 0];
    for n = 1:Npts
	X = x1(:,n)';
	x = x2(1,n); y = x2(2,n); w = x2(3,n);
	A(2*n-1,:) = [  O  -w*X  y*X];
	A(2*n,:) = [ w*X   O  -x*X];
    end

    [~,~,V] = svd(A,0);
    
    % extract homography
    H = reshape(V(:,9),3,3)';
    H = H./H(3,3);
end