
% Clear screen and variables
clear; clc; close all;
addpath 'functions'

% Load data
load 'data.mat';
data = data(:, 9:end);

% "Visualize" data
figure;
scatter3(data(:, 1), data(:, 2), data(:, 3));

% Perform feature reduction
[pca_data, ~, ~, ~] = pca(data, 3);

% Set distance
distance = 'cityblock';

% K-means clustering
figure;
scatter3(pca_data(:, 1), pca_data(:, 2), pca_data(:, 3));
opts = statset('Display', 'final');
[idx,C] = kmeans(pca_data, 2, 'Distance', distance, ...
    'Replicates', 5, 'Options', opts);

% Visualize results
figure;
scatter3(pca_data(idx==1,1),pca_data(idx==1,2),pca_data(idx==1,3),300,'r.');
hold on
scatter3(pca_data(idx==2,1),pca_data(idx==2,2),pca_data(idx==2,3),300,'b.');
% Plot centroids
scatter3(C(:,1),C(:,2),C(:,3),300,'kx');
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off

% How is "appropriate" this clustering?
% Compute the silhouette value for each point in the dataset
% High values correspond to a good match of that sample with its cluster
% and to a bad match with the other(s) cluster(s). Low values correspond to
% the contrary.
figure;
silhouette(pca_data, idx, distance);

% Compute the distribution of samples in the two clusters
predicted__1 = idx == 1;
n1_1 = sum(labels(predicted__1) == 1);
n1_2 = sum(labels(predicted__1) == 2);
predicted__2 = idx == 2;
n2_1 = sum(labels(predicted__2) == 1);
n2_2 = sum(labels(predicted__2) == 2);

% How much are these clusters representative of the "real" classes?
disp(['Cluster 1 contains ' num2str(n1_1) ' samples whose target was 1, ' num2str(n1_2) ' samples whose target was 2.']);
disp(['Cluster 2 contains ' num2str(n2_1) ' samples whose target was 1, ' num2str(n2_2) ' samples whose target was 2.']);

% % Hierarchical clustering
% Z = linkage(pca_data, 'average', distance);
% dendrogram(Z);
% idx = cluster(Z, 'Maxclust', 2);

