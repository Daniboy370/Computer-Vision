function rec_image = reconstruct_laplacian_pyramid(pyramid)

  nLevel = length(pyramid);
  rec_image = pyramid{nLevel}; 
  for i =  nLevel-1 : -1 : 1
    rec_image = rec_image + pyramid{i};
  end
  
end
