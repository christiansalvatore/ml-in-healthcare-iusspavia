
clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');
%
% unit = 509;
% h = figure;
% for channels = 1:32
%     figure(h);
%     plot(g__0(20, (1 + (channels-1)*unit) : channels*unit ));
%     ylim([-30 30])
%     pause;
% end
%
data0 = g__0;
data1 = g__1;
N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
clear data0; clear data1;

% Labels/target
labels = [zeros(1, N0) ones(1, N1)];
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

% Training and parameter tuning
kernel = 'linear';
K = 5;
numvar = size(data, 2);

% Cross-validation index
indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
index = [indices_0; indices_1];

% Metrics
accuracy = 0;
sensitivity = 0;
specificity = 0;

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

        pc_tr_data = squeeze(temp_train_data(:,1:numvar));
        svmStruct = fitcsvm(pc_tr_data, temp_train_labels,...
            'KernelFunction', kernel, 'Standardize', true, ...
            'BoxConstraint', 1);
        svmStruct = compact(svmStruct);

    catch exception

        % disp('Error optimization preprocessing');
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
               
                pc_te_data = squeeze(te_data(:,1:numvar));

                class = predict(svmStruct, pc_te_data)';
                class = cast(class,'double');
                clear pc_te_data;

                % Caso 0 -> Negative
                if temp_tlabel == 0 && class == 0
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

%
%
%
%
% PLOTTING performance wrt the number of variables
% used to train the model
%
%
%
%

clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');
data0 = g__0;
data1 = g__1;
N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
clear data0; clear data1;

% Labels/target
labels = [zeros(1, N0) ones(1, N1)];
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

% Training and parameter tuning
kernel = 'linear';
K = 5;
NUMVAR = 400; %size(data, 2);

% Cross-validation index
indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
index = [indices_0; indices_1];

figure; hold on;

for numvar = 1:NUMVAR
  
    % Metrics
    accuracy = 0;
    sensitivity = 0;
    specificity = 0;

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

        tr_data = temp_train_data;

        try

            pc_tr_data = squeeze(tr_data(:,1:numvar));
            svmStruct = fitcsvm(pc_tr_data, temp_train_labels,...
                'KernelFunction', kernel, 'Standardize', true, ...
                'BoxConstraint', 1);
            svmStruct = compact(svmStruct);

        catch exception

            % disp('Error optimization preprocessing');
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

                    pc_te_data = squeeze(te_data(:,1:numvar));

                    class = predict(svmStruct, pc_te_data)';
                    class = cast(class,'double');
                    clear pc_te_data;

                    % Caso 0 -> Negative
                    if temp_tlabel == 0 && class == 0
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

    scatter(numvar,accuracy); drawnow; hold on;

end

%
%
%
%
% Adding FEATURE REDUCTION techniques
%
%
%
%

clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');
data0 = g__0;
data1 = g__1;
N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
clear data0; clear data1;

% Labels/target
labels = [zeros(1, N0) ones(1, N1)];
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

% Training and parameter tuning
kernel = 'linear';
K = 5;
NUMVAR = 30;

% Cross-validation index
indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
index = [indices_0; indices_1];

figure; hold on;

% Metrics
accuracy = zeros(NUMVAR,1);
sensitivity = zeros(NUMVAR,1);
specificity = zeros(NUMVAR,1);

for numvar = 1:NUMVAR
  
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

        % Feature reduction:
        % PRINCIPAL COMPONENTS ANALYSIS (PCA)
        [tr_data, data_mean, U, Obs] = pca(temp_train_data, numvar);

        try

            pc_tr_data = squeeze(tr_data(:,1:numvar));
            svmStruct = fitcsvm(pc_tr_data, temp_train_labels,...
                'KernelFunction', kernel, 'Standardize', true, ...
                'BoxConstraint', 1);
            svmStruct = compact(svmStruct);

        catch exception

            % disp('Error optimization preprocessing');
            msgString = getReport(exception)

        end

        % TESTING phase
        for subject = 1:size(temp_test_data, 1)

            % Testing data
            temp_tdata = temp_test_data(subject,:);
            temp_tlabel = temp_test_labels(subject);

            % Feature reduction:
            % PRINCIPAL COMPONENTS ANALYSIS (PCA)
            Ntst = 1;
            te_data = dataToPca (temp_tdata, U, data_mean, Ntst);

            if size(te_data,2) == 0

                disp('No data!');

            else

               try

                    pc_te_data = squeeze(te_data(:,1:numvar));

                    class = predict(svmStruct, pc_te_data)';
                    class = cast(class,'double');
                    clear pc_te_data;

                    % Caso 0 -> Negative
                    if temp_tlabel == 0 && class == 0
                        accuracy(numvar, 1) = accuracy(numvar, 1) + (1/size(data, 1));
                        specificity(numvar, 1) = specificity(numvar, 1) + (1/NNeg);
                    end

                    % Caso 1 -> Positive
                    if temp_tlabel == 1 && class == 1
                        accuracy(numvar, 1) = accuracy(numvar, 1) + (1/size(data, 1));
                        sensitivity(numvar, 1) = sensitivity(numvar, 1) + (1/NPos);
                    end

               catch exception

                   disp('Error testing');
                   msgString = getReport(exception)

               end

            end

            clear te_data

        end

    end % cv

    scatter(numvar, accuracy(numvar)); drawnow; hold on;

end

disp('.');
disp('.');
disp('.');
disp('Results');
disp('-----');
[max__acc, ind__] = max(accuracy);
disp(['MAX Accuracy: ' num2str(max__acc)]);
disp(['MAX Sensitivity: ' num2str(sensitivity(ind__))]);
disp(['MAX Specificity: ' num2str(specificity(ind__))]);
disp(['Number of components: ' num2str(ind__)]);

%
%
%
%
% Adding FEATURE RANKING/SELECTION techniques
%
%
%
%

clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');
data0 = g__0;
data1 = g__1;
N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
clear data0; clear data1;

% Labels/target
labels = [zeros(1, N0) ones(1, N1)];
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

% Training and parameter tuning
kernel = 'linear';
K = 5;
NUMVAR = 30;

% Cross-validation index
indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
index = [indices_0; indices_1];

figure; hold on;

% Metrics
accuracy = zeros(NUMVAR,1);
sensitivity = zeros(NUMVAR,1);
specificity = zeros(NUMVAR,1);

for numvar = 1:NUMVAR
  
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

        % Feature reduction:
        % PRINCIPAL COMPONENTS ANALYSIS (PCA)
        [tr_data, data_mean, U, Obs] = pca(temp_train_data, numvar);
        % Feature ranking:
        % FISHER'S DISCRIMINANT RATIO (FDR)
        [tr_data, fdrindex, fdr, unranked__fdr] = ...
            fdrranking(tr_data, temp_train_labels, []);

        try

            pc_tr_data = squeeze(tr_data(:,1:numvar));
            svmStruct = fitcsvm(pc_tr_data, temp_train_labels,...
                'KernelFunction', kernel, 'Standardize', true, ...
                'BoxConstraint', 1);
            svmStruct = compact(svmStruct);

        catch exception

            % disp('Error optimization preprocessing');
            msgString = getReport(exception)

        end

        % TESTING phase
        for subject = 1:size(temp_test_data, 1)

            % Testing data
            temp_tdata = temp_test_data(subject,:);
            temp_tlabel = temp_test_labels(subject);

            % Feature reduction:
            % PRINCIPAL COMPONENTS ANALYSIS (PCA)
            Ntst = 1;
            te_data = dataToPca(temp_tdata, U, data_mean, Ntst);
            % Feature ranking:
            % FISHER'S DISCRIMINANT RATIO (FDR)
            te_data = te_data(:, fdrindex);

            if size(te_data,2) == 0

                disp('No data!');

            else

               try

                    pc_te_data = squeeze(te_data(:,1:numvar));

                    class = predict(svmStruct, pc_te_data)';
                    class = cast(class,'double');
                    clear pc_te_data;

                    % Caso 0 -> Negative
                    if temp_tlabel == 0 && class == 0
                        accuracy(numvar, 1) = accuracy(numvar, 1) + (1/size(data, 1));
                        specificity(numvar, 1) = specificity(numvar, 1) + (1/NNeg);
                    end

                    % Caso 1 -> Positive
                    if temp_tlabel == 1 && class == 1
                        accuracy(numvar, 1) = accuracy(numvar, 1) + (1/size(data, 1));
                        sensitivity(numvar, 1) = sensitivity(numvar, 1) + (1/NPos);
                    end

               catch exception

                   disp('Error testing');
                   msgString = getReport(exception)

               end

            end

            clear te_data

        end

    end % cv

    scatter(numvar, accuracy(numvar)); drawnow; hold on;

end

disp('.');
disp('.');
disp('.');
disp('Results');
disp('-----');
[max__acc, ind__] = max(accuracy);
disp(['MAX Accuracy: ' num2str(max__acc)]);
disp(['MAX Sensitivity: ' num2str(sensitivity(ind__))]);
disp(['MAX Specificity: ' num2str(specificity(ind__))]);
disp(['Number of components: ' num2str(ind__)]);

%
%
%
%
% OPTIMIZING HYPERPARAMETERS
% Nested cross validation
%
%
%
%

clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');
data0 = g__0;
data1 = g__1;
N0 = size(data0, 1);
N1 = size(data1, 1);

% Data matrix + labels'
data0 = double(data0);
data1 = double(data1);
data = double([data0; data1]);
clear data0; clear data1;

% Labels/target
labels = [zeros(1, N0) ones(1, N1)];
original_indices = 1:(N0+N1);
NNeg = N0;
NPos = N1;

% Define training and parameter-tuning settings, which are valid for each
% inner loop and outer loop of the nested cross-validation process
kernel = 'linear';
OUTERK = 5;
INNERK = 5;
NUMVAR = 10;
nestedcv__accuracy = zeros(1, OUTERK);

% Split data and labels in 2 (n) subsets for the outer loop of the nested
% cross-validation process
out_indices_1 = crossvalind('Kfold', N1, OUTERK);
out_indices_0 = crossvalind('Kfold', N0, OUTERK);
outerloop__index = [out_indices_0; out_indices_1];

for outerk = 1:numel(unique(outerloop__index))

    % "Select" (OUTER) TRAINING data based on the index of the outer loop
    outerloop__traindata = ...
        data(outerloop__index ~= outerk, :);
    outerloop__trainlabels = ...
        labels(:, outerloop__index ~= outerk);
    
    % "Select" TESTING data based on the index of the outer loop
    outerloop__testingdata = ...
        data(outerloop__index == outerk, :);
    outerloop__testinglabels = ...
        labels(:, outerloop__index == outerk);    
    
    % Index of the inner loops for this specific outer loop of the
    % cross validation
    % In the inner looops you will have to take into account data from the
    % outerloop__traindata, which will be split again into other K subsets
    innerloop__index = ...
        crossvalind('Kfold', size(outerloop__traindata, 1), INNERK);

    % Metrics
    accuracy = zeros(INNERK, NUMVAR);
    sensitivity = zeros(INNERK, NUMVAR);
    specificity = zeros(INNERK, NUMVAR);

    for innerk = 1:numel(unique(innerloop__index))
        
        % "Select" (INNER) TRAINING data based on the index of the inner loop
        innerloop__traindata = ...
            outerloop__traindata(innerloop__index ~= innerk, :);
        innerloop__trainlabels = ...
            outerloop__trainlabels(:, innerloop__index ~= innerk);

        % "Select" VALIDATION data based on the index of the inner loop
        innerloop__validationdata = ...
            outerloop__traindata(innerloop__index == innerk, :);
        innerloop__validationlabels = ...
            outerloop__trainlabels(:, innerloop__index == innerk);          
        
        for numvar = 1:NUMVAR

            % TRAINING phase
            
            % Feature reduction:
            % PRINCIPAL COMPONENTS ANALYSIS (PCA)
            [tr_data, data_mean{innerk, numvar}, U{innerk, numvar}, Obs] = ...
                pca(innerloop__traindata, numvar);
            % Feature ranking:
            % FISHER'S DISCRIMINANT RATIO (FDR)
            [tr_data, fdrindex{innerk, numvar}, fdr, unranked__fdr] = ...
                fdrranking(tr_data, innerloop__trainlabels, []);

            pc_tr_data = squeeze(tr_data(:,1:numvar));
            svmStruct = fitcsvm(pc_tr_data, innerloop__trainlabels,...
                'KernelFunction', kernel, 'Standardize', true, ...
                'BoxConstraint', 1);
            model{innerk, numvar} = compact(svmStruct);
            clear svmStruct

            % VALIDATION phase
            for subject = 1:size(innerloop__validationdata, 1)

                % Validation data
                temp_tdata = innerloop__validationdata(subject,:);
                temp_tlabel = innerloop__validationlabels(subject);

                % Feature reduction:
                % PRINCIPAL COMPONENTS ANALYSIS (PCA)
                Ntst = 1;
                te_data = dataToPca(temp_tdata, ...
                    U{innerk, numvar}, data_mean{innerk, numvar}, Ntst);
                % Feature ranking:
                % FISHER'S DISCRIMINANT RATIO (FDR)
                te_data = te_data(:, fdrindex{innerk, numvar});

                if size(te_data, 2) == 0

                    disp('No data!');

                else

                    class = predict(model{innerk, numvar}, te_data)';
                    class = cast(class,'double');

                    % Caso 0 -> Negative
                    if temp_tlabel == 0 && class == 0
                        accuracy(innerk, numvar) = ...
                            accuracy(innerk, numvar) + ...
                            (1/size(innerloop__validationdata, 1));
                    end

                    % Caso 1 -> Positive
                    if temp_tlabel == 1 && class == 1
                        accuracy(innerk, numvar) = ...
                            accuracy(innerk, numvar) + ...
                            (1/size(innerloop__validationdata, 1));
                    end

                end

            end % validation

        end % numvar
        
    end % innerk
    
    % Select the best model (in terms of classification performance in the
    % inner loop
    % The evaluation metric can be chosen according to the specific
    % problem; here, we use accuracy for general purposes
    [m__, ind__] = max(accuracy(innerk, :));
    % Identify the best model for this specific inner loop
    best__model = model{innerk, ind__};
    % Identify the corresponding feature reduction/ranking parameters
    best__datamean = data_mean{innerk, ind__};
    best__U = U{innerk, ind__};
    best__fdrindex = fdrindex{innerk, ind__};
    
    % TESTING phase
    % Apply the best model to the testing samples of the corresponding
    % outer loop
    for test__subject = 1:size(outerloop__testingdata, 1)

        % Testing data
        temp_tdata = outerloop__testingdata(test__subject,:);
        temp_tlabel = outerloop__testinglabels(test__subject);

        % Feature reduction:
        % PRINCIPAL COMPONENTS ANALYSIS (PCA)
        Ntst = 1;
        te_data = dataToPca(temp_tdata, best__U, best__datamean, Ntst);
        % Feature ranking:
        % FISHER'S DISCRIMINANT RATIO (FDR)
        te_data = te_data(:, best__fdrindex);

        class = predict(best__model, te_data)';
        class = cast(class,'double');

        if temp_tlabel == class
            nestedcv__accuracy(1, outerk) = ...
                nestedcv__accuracy(1, outerk) + ...
                (1/size(outerloop__testingdata, 1));
        end

    end % testing
    
end % outerk

disp('.');
disp('.');
disp('.');
disp('Results');
disp('-----');
disp(['Accuracy: ' num2str(mean(nestedcv__accuracy)) ' +/- ' num2str(std(nestedcv__accuracy))]);
