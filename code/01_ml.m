
clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
[data, labels] = loading__fromexcel();
data0 = data(labels == 0, :);
data1 = data(labels == 1, :);

N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
labels = [zeros(1, N0) ones(1, N1)];
clear data0; clear data1;

% Sample information
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

%
%
%

% Principal Components Analysis
[coeff,score,latent] = pca(X);

% Fisher Discriminant Ratio
...
    
% Clustering k-means
idx = kmeans(X,k);

% K-nearest neighbors
idx = knnsearch(X,Y);

% Decision tree
Mdl = fitctree(X,Y);
label = predict(Mdl,X);

% Support vector machine
Mdl = fitcsvm(X,target,'KernelFunction','rbf',...
    'BoxConstraint',Inf);
label = predict(Mdl,X);

% Ensemble learning
% https://it.mathworks.com/help/stats/framework-for-ensemble-learning.html#bsw8akh
Mdl = fitcensemble(Tbl,ResponseVarName);
label = predict(Mdl,X);
