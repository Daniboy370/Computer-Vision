function pyramid = laplacian_pyramid(img, nLevel)
    pyramid=cell(nLevel,1);

    % pyramids{1} = I
    % pyramids{2} = IxG(2^2)
    % pyramids{i} = IxG(2^i)
    pyramid{1}=img;
    for i = 2 : nLevel
      sigma=2^(i);
      kernel=fspecial('gaussian', sigma*5, sigma); 
      pyramid{i} = imfilter(img, kernel, 'symmetric');
    end

    % pyramids{1} = pyramids{1}-pyramids{2} = I-IxG(2^2)
    % pyramids{2} = pyramids{2}-pyramids{3} = IxG(2^2)-IxG(2^3)
    % pyramids{i} = pyramids{i}-pyramids{i+1} = IxG(2^i)-IxG(2^(i+1))
    for i = 1 : nLevel-1
      pyramid{i} = (pyramid{i}-pyramid{i+1});
    end

    % pyramids{n} = IxG(2^n)
    pyramid{nLevel} = pyramid{nLevel};
end
