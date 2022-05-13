
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

% Divide data into 2 classes
binary_labels = numeric_labels(numeric_labels == 1 | numeric_labels == 2);
binary_data = data_matrix(numeric_labels == 1 | numeric_labels == 2, :);
sum(binary_labels == 1)
sum(binary_labels == 2)

%
%
%
% CLASSIFICATION
%
%
%

% Decision tree
tree_model = fitctree(binary_data, binary_labels);

% Visualize the tree structure
view(tree_model,'Mode','graph')

% Use a built-in function to crossvalidate the model
tree_cvmodel = crossval(tree_model);
L = kfoldLoss(tree_cvmodel)

% Implement cross validation
...

%
%
%

figure; hold on
maxleafsize = 50
for i = 1:maxleafsize
    leafsize = maxleafsize - i + 1;
    tree_model = fitctree(binary_data, binary_labels, 'MinLeafSize', leafsize);
    tree_cvmodel = crossval(tree_model);
    L = kfoldLoss(tree_cvmodel)
    scatter(i, L)
end

% Try to do the same by using a distinct training and testing sets
global_index = logical(zeros(1,size(binary_data, 1)));
train_index = randperm(size(binary_data, 1), 65000);
global_index(train_index) = true;
global_index(~train_index) = false;
binary_trainlabels = binary_labels(global_index);
binary_traindata = binary_data(global_index,:);
binary_testlabels = binary_labels(~global_index);
binary_testdata = binary_data(~global_index,:);
figure; hold on
maxleafsize = 50
for i = 1:maxleafsize
    leafsize = maxleafsize - i + 1;
    tree_model = fitctree(binary_traindata, binary_trainlabels, 'MinLeafSize', leafsize);
    predicted_testlabels = predict(tree_model, binary_testdata);
    cp = classperf(binary_testlabels, predicted_testlabels);
    treemodel_accuracy(i) = cp.CorrectRate;
    scatter(i, 1-treemodel_accuracy(i))
    
    % Superimpose train accuracy
    predicted_trainlabels = predict(tree_model, binary_traindata);
    cp = classperf(binary_trainlabels, predicted_trainlabels);
    treemodel_trainaccuracy(i) = cp.CorrectRate;
    scatter(i, 1-treemodel_trainaccuracy(i))
    
    drawnow
end

% Is the dataset well balanced?
% If not, how do sensitivity and specificity behave?
% What is the value of dominance or gemoetric mean of
% sensitivity and specificty?
...

%
%
%

% Support Vector Machine
% Warning: the computational time for SVM is much higher, consider using a
% small subset of data
index_ = randperm(size(binary_data, 1), 1000);
indata = binary_data(index_,:);
inlabels = binary_labels(index_,:);
Mdl = fitcsvm(indata, inlabels, 'KernelFunction', 'linear');
svm_predictedtrainlabel = predict(Mdl, binary_data);

% Modify 'KernelFunction' -> e.g. 'linear'
% Modify 'BoxConstraint' -> e.g. 10

correctpredictions_svm = (svm_predictedtrainlabel == binary_labels);
100*sum(correctpredictions_svm)/size(correctpredictions_svm,1)

%
%
%

% Ensemble learning
% Random Forest
NumTrees = 10;
Mdl = TreeBagger(NumTrees,binary_data,binary_labels);

figure; hold on
for i = 1:50
    NumTrees = i;
    rf_model = TreeBagger(NumTrees,binary_data,binary_labels);
    predicted_testlabels = predict(rf_model, binary_testdata);
    predicted_testlabels = cell2mat(predicted_testlabels);
    predicted_testlabels = str2num(predicted_testlabels);
    cp = classperf(binary_testlabels, predicted_testlabels);
    rfmodel_accuracy(i) = cp.CorrectRate;
    scatter(i, 1-rfmodel_accuracy(i))
    
    % Superimpose train accuracy
    predicted_trainlabels = predict(rf_model, binary_traindata);
    predicted_trainlabels = cell2mat(predicted_trainlabels);
    predicted_trainlabels = str2num(predicted_trainlabels);    
    cp = classperf(binary_trainlabels, predicted_trainlabels);
    rfmodel_trainaccuracy(i) = cp.CorrectRate;
    scatter(i, 1-rfmodel_trainaccuracy(i))
    
    drawnow
end

% Other techniques, like Adaboost
% https://it.mathworks.com/help/stats/framework-for-ensemble-learning.html#bsw8akh
Mdl = fitcensemble(binary_data, binary_labels, 'Method', 'AdaBoostM1');

%
%
%

%  Add feature extraction to the original dataset to see if the performance
%  are improved
...
    
%
%
%

% Add feature selection to the original dataset to see if the perofrmnace
% are improved
...
    
%
%
%

% Try to implement cross validation like follows
N1 = sum(binary_labels == 1);
N2 = sum(binary_labels == 2);
NNeg = N2;
NPos = N1;
K = 5;
% Cross-validation index
indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
indices_2 = crossvalind('Kfold', N2, K); %GROUP_2
index = [indices_1; indices_2];

% Metrics
accuracy = 0;
sensitivity = 0;
specificity = 0;

data = binary_data;
labels = binary_labels;

original_indices = (1:size(binary_data,1));

for ind = 1:K
    disp(['K = ' num2str(ind)]);
    
    temp_train_set = true(1,size(data,1));
    temp_train_set(index == ind) = false;
    temp_test_set =~temp_train_set;

    temp_train_indices = original_indices(temp_train_set);
    temp_test_indices = original_indices(temp_test_set);

    temp_train_labels = labels(temp_train_indices);
    temp_test_labels = labels(temp_test_indices);
    
    temp_train_data = data(temp_train_indices,:);
    temp_test_data = data(temp_test_indices,:); 

    try

        tree_model = fitctree(temp_train_data, temp_train_labels);

    catch exception

        msgString = getReport(exception)

    end

    % TESTING phase
    for subject = 1:size(temp_test_data, 1)

        % Testing data
        temp_tdata = temp_test_data(subject,:);
        temp_tlabel = temp_test_labels(subject);

        te_data = temp_tdata;

        if size(te_data,2) == 0
            
            disp('No data!');
        
        else
            
           try
               
                class = predict(tree_model, te_data)';
                class = cast(class,'double');

                % Caso 0 -> Negative
                if temp_tlabel == 2 && class == 2
                    accuracy = accuracy + (1/size(data, 1));
                    specificity = specificity + (1/NNeg);
                end

                % Caso 1 -> Positive
                if temp_tlabel == 1 && class == 1
                    accuracy = accuracy + (1/size(data, 1));
                    sensitivity = sensitivity + (1/NPos);
                end
                
           catch exception
        
               disp('Error testing');
               msgString = getReport(exception)
           
           end
           
        end

        clear te_data

    end
        
end % cv

disp('.');
disp('.');
disp('.');
disp('Results');
disp('-----');
disp(['Accuracy: ' num2str(accuracy)]);
disp(['Sensitivity: ' num2str(sensitivity)]);
disp(['Specificity: ' num2str(specificity)]);
