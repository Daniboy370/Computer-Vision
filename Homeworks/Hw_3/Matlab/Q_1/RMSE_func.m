function output = RMSE_func(a, b)

output = sqrt(mean( (a - b).^2, 'all' ))*(100/255);

end