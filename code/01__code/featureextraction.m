% https://www.kaggle.com/datasets/fedesoriano/stellar-classification-dataset-sdss17

% HINT: you may also run the single-line commands by writing them in the
% terminal or by highlighting a line and pressing F9

%
%
%

addpath(genpath('../02__data'));
% addpath(genpath('./.'));

%
%
%

% Load data
data_path = 'star_classification.csv';
data = readtable(data_path);

sample_id = data.obj_ID;
string_labels = data.class;
unique(string_labels)
numeric_labels = ...
    1 * strcmpi(string_labels,'STAR') + ...
    2 * strcmpi(string_labels,'GALAXY') + ...
    3 * strcmpi(string_labels,'QSO'); % Quasar

sum(numeric_labels == 1) / size(numeric_labels, 1)
sum(numeric_labels == 2) / size(numeric_labels, 1)
sum(numeric_labels == 3) / size(numeric_labels, 1)

data_orig = data;
data = data_orig(:,2:8);

histfit(data.alpha)
pause(3)
boxplot(data.alpha, string_labels)
pause(3)
boxplot(data.delta, string_labels)
pause(3)
boxplot(data.u, string_labels)
pause(3)
boxplot(data.g, string_labels)
pause(3)
boxplot(data.r, string_labels)
pause(3)
boxplot(data.i, string_labels)
pause(3)
boxplot(data.z, string_labels)
close all

% What is the minimum of data.z?
[minimum, index] = min(data.z)

% Remove such records?
index = true(size(data,1),1);
index(79544,1) = false;
data = data(index,:);
string_labels = string_labels(index,:);
numeric_labels = numeric_labels(index,:);

% What is the new minimum?
...
    
%
%
%
% FEATURE EXTRACTION
%
%
%
    
%
%
% Extract features from this 8-feature set of data
%
%
    
data_matrix = data{:,:};

% PRINCIPAL COMPONENTS ANALYSIS
% Subtract the mean
mean_adjusted_data = data_matrix - mean(data_matrix);

% Calculate the covariance matrix
covarianceMatrix = cov(mean_adjusted_data);

% Calculate eigenvalues and eigenvectors of the covariance matrix
[V, D] = eig(covarianceMatrix);

% V are the eigenvectors of the covariance matrix.
% Compare the columns of coeff and V.
V

% Multiply the original data (mean adjusted) by V
% to get the projections on the PCA space.
% The results are also called "scores"

pca_data = mean_adjusted_data * V;

% Evaluate the variance of the pca_data
% This is also called "latent"
var(pca_data)'

% Finally, using the built-in matlab function, you will reach the same
% results (unless otherwise ranked)
[coeff, score, latent, ~, explained] = pca(mean_adjusted_data);

% Hint: visualize the original data and the "transformed" PCA data using a
% scatter plot
scatter(data_matrix(:,1), data_matrix(:,2), 'MarkerEdgeColor',[0 0 1], 'MarkerFaceColor', [0 0 1]) % Blue

% PCA number 6 and 7 (depends on the ranking)
scatter(pca_data(:,6), pca_data(:,7), 'MarkerEdgeColor',[1 0 0], 'MarkerFaceColor', [1 0 0]) % Red

% As shown, the first two variables of the original data are very similar to pca_data
% In this case, PCA does not contribute much to the aim of extracting
% "better" features for the model

% Can you plot data with respect to different classes?
