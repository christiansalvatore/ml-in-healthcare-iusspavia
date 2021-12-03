
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

data0 = data(labels==0,:);
data1 = data(labels==1,:);
traindata = [data0(1:40,:); data1(1:40,:)];
testingdata = [data0(41:45,:); data1(41:85,:)];
trainlabel = [zeros(1,40), ones(1,40)];
testlabel = [zeros(1,5), ones(1,45)];

%
%
%

% FEATURE EXTRACTION
% Principal Components Analysis
[coeff,score,latent] = pca(traindata);
% Rows of X correspond to observations and columns to variables.
expl_var_1 = 100*latent(1)/sum(latent,1);
for i = 1:13
    expl_var(i) = 100*sum(latent(1:i),1)/sum(latent,1);
end
score1 = score(:,1);
score2 = score(:,2);
figure; scatter(score1, score2);

score1_label1 = score(trainlabel==1,1);
score2_label1 = score(trainlabel==1,2);
score1_label0 = score(trainlabel==0,1);
score2_label0 = score(trainlabel==0,2);
figure;
scatter(score1_label1, score2_label1);
hold on
scatter(score1_label0, score2_label0);

%
%
%

% FEATURE SELECTION
% Fisher Discriminant Ratio
% Try to implement the formula from lesson #1
[outputdata, index, fdr, unranked__fdr] = fdrranking(traindata, trainlabel, []);
score1_label1_fdr = outputdata(trainlabel==1,1);
score2_label1_fdr = outputdata(trainlabel==1,2);
score1_label0_fdr = outputdata(trainlabel==0,1);
score2_label0_fdr = outputdata(trainlabel==0,2);
figure;
scatter(score1_label1_fdr, score2_label1_fdr);
hold on
scatter(score1_label0_fdr, score2_label0_fdr);

data_fdr = outputdata;

%
%
%
  
% CLASSIFICATION
% Clustering k-means
k = 3; % How many clusters?
idx = kmeans(traindata, k);
my_labels = trainlabel';
corretti_ipotesi1 = 0;
for i = 1:size(my_labels, 1)
    if (my_labels(i,1) == 0 && idx(i,1) == 1) || ...
        (my_labels(i,1) == 1 && idx(i,1) == 2)
    
        corretti_ipotesi1 = corretti_ipotesi1 + 1;
        
    end
end

corretti_ipotesi2 = 0;
for i = 1:size(my_labels, 1)
    if (my_labels(i,1) == 0 && idx(i,1) == 2) || ...
        (my_labels(i,1) == 1 && idx(i,1) == 1)
    
        corretti_ipotesi2 = corretti_ipotesi2 + 1;
        
    end
end

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

Mdl = fitcsvm(traindata, trainlabel, 'KernelFunction', 'linear',...
    'BoxConstraint', 10);
trainlabel_svm = predict(Mdl, traindata);

correct_svm = (trainlabel_svm == trainlabel');
100*sum(correct_svm)/size(correct_svm,1)

%

score_pca = [score1 score2];

Mdl = fitcsvm(score_pca, trainlabel, 'KernelFunction', 'linear',...
    'BoxConstraint', 10);
trainlabel_svm = predict(Mdl, score_pca);

correct_svm = (trainlabel_svm == trainlabel');
100*sum(correct_svm)/size(correct_svm,1)

%

data_fdr_12 = data_fdr(:,1:4);

Mdl = fitcsvm(data_fdr_12, trainlabel, 'KernelFunction', 'linear',...
    'BoxConstraint', 10);
trainlabel_svm = predict(Mdl, data_fdr_12);

correct_svm = (trainlabel_svm == trainlabel');
100*sum(correct_svm)/size(correct_svm,1)

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

