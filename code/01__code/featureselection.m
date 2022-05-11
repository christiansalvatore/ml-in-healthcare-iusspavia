% https://www.kaggle.com/datasets/fedesoriano/stellar-classification-dataset-sdss17

%
%
%

addpath(genpath('../02__data'));
% addpath(genpath('./.'));

% Clear variables (optional)
clear all

%
%
%

% DATA LOADING AND PREPROCESSING
% BEGINNING
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

% What is the minimum of data.z?
[minimum, index] = min(data.z)

% Remove such records?
index = true(size(data,1),1);
index(79544,1) = false;
data = data(index,:);
string_labels = string_labels(index,:);
numeric_labels = numeric_labels(index,:);

data_matrix = data{:,:};

%
%
%
% DATA LOADING AND PREPROCESSING
% END

%
%
%
% FEATURE SELECTION
%
%
%

% Select features from this 7-feature set of data
    
% MUTUAL INFORMATION
mutualinfo = mutual_information(data_matrix);

%
%
%
    
% NEAR-ZERO VARIANCE
% Try to compute variance
for i = 1:7
    var_(i) = var(data_matrix(:,i));
end
% Compute near-zero variance index (logical 0 = there is no near-zero-variance
% issue with that feature)
nearzerovar__index = nearzero_variance(data_matrix);

%
%
%
    
% FISHER'S DISCRIMINANT RATIO
[outputdata, index, fdr, unranked__fdr] = fdr(data_matrix, numeric_labels, []);

% Which features are the most important for classification according to
% FDR? --> index
