
% Prepare data

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
data_path = 'Crystal_structure.csv';
data = readtable(data_path);

string_labels = data.LowestDistortion;
unique(string_labels)
numeric_labels = ...
    1 * strcmpi(string_labels,'cubic') + ...
    2 * strcmpi(string_labels,'orthorhombic') + ...
    3 * strcmpi(string_labels,'rhombohedral') + ...
    4 * strcmpi(string_labels,'tetragonal');

sum(numeric_labels == 1) / size(numeric_labels, 1)
sum(numeric_labels == 2) / size(numeric_labels, 1)
sum(numeric_labels == 3) / size(numeric_labels, 1)
sum(numeric_labels == 4) / size(numeric_labels, 1)

data_orig = data;
data = data_orig(~strcmpi(data.LowestDistortion, '-'),[5:15 17]);

data_matrix = data{:,:};

% Remove NaN recordssamples
flag = false(size(data_matrix,1), 1);
for i = 1:size(data_matrix, 1)
    for j = 1:size(data_matrix,2)
        if isnan(data_matrix(i,j))
            flag(i) = true;
        end
    end
end     
data_matrix = data_matrix(~flag,:);
numeric_labels = numeric_labels(~flag,:);

min(min(data_matrix))
max(max(data_matrix))

%
%
%
% DATA LOADING AND PREPROCESSING
% END

% Divide data into 2 classes
% Chose 2 classes
binary_labels = numeric_labels(numeric_labels == 1 | numeric_labels == 2);
binary_data = data_matrix(numeric_labels == 1 | numeric_labels == 2, :);
sum(binary_labels == 1)
sum(binary_labels == 2)
