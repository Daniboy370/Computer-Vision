function gain = compute_gain_one_chanel(img, example_img, nLevel)
    % compute laplacian pyramids
    img_lap_pyramid = laplacian_pyramid(img, nLevel);
    example_img_lap_pyramid = laplacian_pyramid(example_img, nLevel);

    % compute enegry 
    img_enegry = compute_energy(img_lap_pyramid, nLevel);
    example_img_energy = compute_energy(example_img_lap_pyramid, nLevel);

    % compute gain:
    EPSILON = 0.0001;
    MAX_VALUE = 2.8;
    MIN_VALUE = 0.9;
    
    gain = cell(nLevel,1);
    for i = 1:nLevel
        gain{i} = sqrt(example_img_energy{i} ./ (img_enegry{i} + EPSILON));
        gain{i} = max(min(gain{i}, MAX_VALUE), MIN_VALUE);
    end
    
end

function [energy] = compute_energy(laplacian_pyramid, levels)
    energy = cell(levels,1);
    for i = 1:levels
        sigma=2^(i+1);
        kernel=fspecial('gaussian', sigma*5, sigma); 
        energy{i} = imfilter( (laplacian_pyramid{i}.* laplacian_pyramid{i}), kernel, 'symmetric');
    end
end
