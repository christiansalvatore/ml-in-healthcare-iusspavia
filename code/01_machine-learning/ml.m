
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
[coeff,score,latent] = pca(data);
% Rows of X correspond to observations and columns to variables.

%
%
%

% Fisher Discriminant Ratio
% Try to implement the formula from lesson #1

%
%
%
    
% Clustering k-means
k = []; % How many clusters?
idx = kmeans(data, k);

%
%
%

% K-nearest neighbors
% KNNSEARCH(X,Y) finds the nearest neighbor in X for each point in Y
idx = knnsearch(data(1:129,:), data(130,:));
predicted_label = labels(idx);

%
%
%

% Decision tree
Mdl = fitctree(data(1:129,:), labels(1:129));
label = predict(Mdl, data(130,:));

%
%
%

% Support vector machine
Mdl = fitcsvm(X, target, 'KernelFunction', 'rbf',...
    'BoxConstraint', Inf);
label = predict(Mdl, X);

%
%
%

% Ensemble learning
% https://it.mathworks.com/help/stats/framework-for-ensemble-learning.html#bsw8akh
Mdl = fitcensemble(data(1:129,:), labels(1:129));
label = predict(Mdl, data(130,:));

%
%
%

