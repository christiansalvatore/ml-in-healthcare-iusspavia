function original__data = pca2data (data, U, data_mean, Obs)

% My function
original__data = (U' * data') + (repmat(data_mean, Obs, 1))';
    
% % MATLAB function
% original__data = (data * U') + repmat(data_mean, Obs, 1);

end
