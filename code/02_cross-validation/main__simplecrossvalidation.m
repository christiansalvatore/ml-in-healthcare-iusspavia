
clear; clc;
addpath 'functions'

GROUP_0 = 'negativi';
GROUP_1 = 'positivi';

% Loading data
load('data/signal__b.mat');

% unit = 509;
% h = figure;
% for channels = 1:32
%     figure(h);
%     plot(g__0(20, (1 + (channels-1)*unit) : channels*unit ));
%     ylim([-30 30])
%     pause;
% end

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
