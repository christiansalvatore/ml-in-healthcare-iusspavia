
% clear; clc;
% addpath 'functions'
% 
% GROUP_0 = 'negativi';
% GROUP_1 = 'positivi';
% 
% % Loading data
% [data, labels] = loading__fromexcel();
% data0 = data(labels == 0, :);
% data1 = data(labels == 1, :);
% 
% N0 = size(data0, 1);
% N1 = size(data1, 1);
% 
% % Data matrix + labels'
% data0 = double(data0);
% data1 = double(data1);
% data = double([data0; data1]);
% labels = [zeros(1, N0) ones(1, N1)];
% clear data0; clear data1;
% 
% % Sample information
% original_indices = 1:(N0+N1);
% NNeg = N0;
% NPos = N1;
% 
% % Training and parameter tuning
% kernel = 'linear';
% K = 5;
% numvar = size(data, 2);
% 
% % Cross-validation index
% indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
% indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
% index = [indices_0; indices_1];
% 
% % Metrics
% accuracy = 0;
% sensitivity = 0;
% specificity = 0;
% 
% for ind = 1:K
%     disp(['K = ' num2str(ind)]);
%     
%     temp_train_set = true(1,size(data,1));
%     temp_train_set(index == ind) = false;
%     temp_test_set =~temp_train_set;
% 
%     temp_train_indices = original_indices(temp_train_set);
%     temp_test_indices = original_indices(temp_test_set);
% 
%     temp_train_labels = labels(temp_train_indices);
%     temp_test_labels = labels(temp_test_indices);
%     
%     temp_train_data = data(temp_train_indices,:);
%     temp_test_data = data(temp_test_indices,:); 
% 
%     try
% 
%         pc_tr_data = squeeze(temp_train_data(:,1:numvar));
%         svmStruct = fitcsvm(pc_tr_data, temp_train_labels,...
%             'KernelFunction', kernel, 'Standardize', true, ...
%             'BoxConstraint', 1);
%         svmStruct = compact(svmStruct);
% 
%     catch exception
% 
%         % disp('Error optimization preprocessing');
%         msgString = getReport(exception)
% 
%     end
% 
%     % TESTING phase
%     for subject = 1:size(temp_test_data, 1)
% 
%         % Testing data
%         temp_tdata = temp_test_data(subject,:);
%         temp_tlabel = temp_test_labels(subject);
% 
%         te_data = temp_tdata;
% 
%         if size(te_data,2) == 0
%             
%             disp('No data!');
%         
%         else
% 
%             pc_te_data = squeeze(te_data(:,1:numvar));
% 
%             class = predict(svmStruct, pc_te_data)';
%             class = cast(class,'double');
%             clear pc_te_data;
% 
%             % Caso 0 -> Negative
%             if temp_tlabel == 0 && class == 0
%                 accuracy = accuracy + (1/size(data, 1));
%                 specificity = specificity + (1/NNeg);
%             end
% 
%             % Caso 1 -> Positive
%             if temp_tlabel == 1 && class == 1
%                 accuracy = accuracy + (1/size(data, 1));
%                 sensitivity = sensitivity + (1/NPos);
%             end
%            
%         end
% 
%         clear te_data
% 
%     end
%         
% end % cv
% 
% disp('.');
% disp('.');
% disp('.');
% disp('Results');
% disp('-----');
% disp(['Accuracy: ' num2str(accuracy)]);
% disp(['Sensitivity: ' num2str(sensitivity)]);
% disp(['Specificity: ' num2str(specificity)]);


clear; clc;
% rng(1); % For reproducibility
        
params.datetimestr = [datestr(date) '__' num2str(randi(10e10))];
params.datetime = datetime;

for iterations = 1:1
    
    % Setup: create necessary folders/subfolders
    mkdir('temp')
    mkdir('temp/optimal_configurations')
    mkdir('temp/optimal_configurations/svmstruct')
    mkdir('temp/optimal_configurations/performance')    
    
    % Label assignment
    GROUP_0 = 'positive';
    GROUP_1 = 'negative';

    %
    %
    %
    %
    %
    % TRAINING
    % and parameter tuning
    %
    %
    %
    %
    %
    
    % Setup classification and validation parameters
    % SVM kernel
    kernel = 'linear';
    % Number of cross-validation folds
    K = 5;

    % Loading data
    [data, label] = loading__fromexcel();
    data0 = data(label == 0, :);
    data1 = data(label == 1, :);
    N0 = size(data0, 1);
    N1 = size(data1, 1);
    sbjs = N0 + N1;

    % Save some data for the second part of the script
    freeze.data0 = data0;
    freeze.N0 = N0;
    freeze.data1 = data1;
    freeze.N1 = N1;

    % Define train-data matrix and labels
    data0 = double(data0);
    data1 = double(data1);
    train_data = double([data0; data1]); clear data0; clear data1;

    train_labels = [zeros(1,N0) ones(1,N1)];
    original_indices = 1:(N0+N1);

    % Number of variables
    generic__numvar = size(data, 2);

    % Box constraint
    box__constraint = 1;
    % Tip for optimizing box constraint
    % box__constraint = logspace(-3, 3, 5);
    %
    % Other SVM parameters that can be optimized:
    % Standardization
    % Kernel
    % KernelScale

    % Creating structures for saving performance/results
    optim__acc = zeros(K, K, generic__numvar, size(box__constraint, 2));
    optim__sen = zeros(K, K, generic__numvar, size(box__constraint, 2));
    optim__spe = zeros(K, K, generic__numvar, size(box__constraint, 2));

    nestedcv__acc = zeros(K, 1);
    nestedcv__sen = zeros(K, 1);
    nestedcv__spe = zeros(K, 1);

    %
    % Nested cross-validation indices
    % indices_outerloop
    % Initialize the index for the outer loop of the nested cross
    % validation respecting the class proportion in each round
    % (stratified)
    %

    indices_file = ...
        dir(fullfile('temp',['outerloopindices__' num2str(K) '.mat']));
    if isempty(indices_file)
        indices_1 = crossvalind('Kfold', N1, K); %GROUP_1
        indices_0 = crossvalind('Kfold', N0, K); %GROUP_0
        indices_outerloop = [indices_0; indices_1];
        save(['temp/outerloopindices__' num2str(K) '.mat'],...
            'indices_outerloop');
        disp('Indices correctly created.');
    else
        load(['temp/' indices_file(1).name]);
    end

    cv.indices_outerloop = indices_outerloop;
    cv.k = K;

    for outerk = 1:K
        disp(['K = ' num2str(outerk)]);
        outer_train_set = true(1,size(train_data,1));
        outer_train_set(cv.indices_outerloop==outerk) = false;
        outer_test_set =~outer_train_set;

        outer_train_indices = original_indices(outer_train_set);
        outer_test_indices = original_indices(outer_test_set);

        outer_train_labels = train_labels(outer_train_indices);

        %
        % Nested cross-validation indices
        % indices_innerloop
        % Initialize the index for the inner loop of the nested cross
        % validation respecting the class proportion in each round
        % (stratified)
        %

        indices_file = ...
            dir(fullfile('temp',...
            ['innerloopindices__' num2str(outerk) '-' num2str(K) '.mat']));
        if isempty(indices_file)
            indices_1 = crossvalind('Kfold',...
                sum(outer_train_labels == 1),K); % GROUP_1
            indices_0 = crossvalind('Kfold',...
                sum(outer_train_labels == 0),K); % GROUP_0
            temp__ind = NaN(1,sum(outer_train_labels == 1) +...
                sum(outer_train_labels == 0));
            temp__position = (1:size(temp__ind,2));
            temp__ind(temp__position(outer_train_labels == 1)) =...
                indices_1;
            temp__ind(temp__position(outer_train_labels == 0)) =...
                indices_0;
            indices_innerloop = temp__ind;
            save(['temp/innerloopindices__'...
                num2str(outerk) '-' num2str(K) '.mat'],...
                'indices_innerloop');
            disp('Innerloop indices correctly created.');
        else
            load(['temp/' indices_file(1).name]);
        end            

        cv.indices_innerloop{outerk} = indices_innerloop;
        clear indices_innerloop temp__ind temp__position

        % Nested parameter optimization
        for innerk = 1:K

            inner_test_indices = outer_train_indices...
                (1, cv.indices_innerloop{outerk} == innerk);
            inner_train_indices = setdiff...
                (outer_train_indices, inner_test_indices);

            inner_train_labels = train_labels(inner_train_indices);
            inner_test_labels = train_labels(inner_test_indices);

            inner_train_data = train_data(inner_train_indices,:);
            inner_test_data = train_data(inner_test_indices,:); 

            inner_P_train = size(inner_train_data,1);
            inner_Pfeat_train = size(inner_train_data, 2);
            num__variables = min(inner_P_train, inner_Pfeat_train) - 1;        
            inner_P_test = size(inner_test_data,1);     

            NNeg = sum(inner_test_labels == 0);
            NPos = sum(inner_test_labels == 1);

            try
                
                % Preprocessing: training data
                tr_data = inner_train_data;

                % Feature ranking: Fisher's Discriminant Ratio (FDR)
                [tr_data, modelparameters, ~, ~] = ...
                    fdrranking(tr_data(:,:), ...
                    inner_train_labels', []);  

                for numvar = 1:num__variables
                for bc = 1:size(box__constraint, 2)

                    try
                    pc_tr_data = squeeze(tr_data(:,1:numvar));
                    svmStruct = fitcsvm(pc_tr_data, inner_train_labels,...
                        'KernelFunction', kernel, 'Standardize', true, ...
                        'BoxConstraint', box__constraint(bc));
                    svmStruct = compact(svmStruct);
                    save(['temp/optimal_configurations/svmstruct/'...
                        GROUP_0 '_' GROUP_1 '_' num2str(numvar) '_' ...
                        num2str(bc) '_' num2str(outerk)...
                        num2str(innerk) '.mat'], 'svmStruct');
                    clear svmStruct
                    catch exception
                        % disp('Error optimization preprocessing');
                        msgString = getReport(exception)
                    end
                    clear pc_tr_data

                end
                end
                clear tr_data

                for subject = 1:inner_P_test

                    % Testing data
                    inner_test = inner_test_data(subject,:,:,:);
                    inner_test_label = inner_test_labels(subject);

                    % Feature ranking:
                    % Fisher's Discriminant Ratio (FDR)
                    te_data = inner_test(modelparameters);

                    for numvar = 1:num__variables
                    for bc = 1:size(box__constraint, 2)

                        if size(te_data,2) == 0
                            disp('No data!');
                        else
                           try
                                pc_te_data = squeeze(te_data(:,1:numvar));
                                load(['temp/optimal_configurations/svmstruct/' ...
                                    GROUP_0 '_' GROUP_1 '_' num2str(numvar) ...
                                    '_' num2str(bc) '_' num2str(outerk) num2str(innerk) '.mat']);
                                class = predict(svmStruct, pc_te_data)';
                                clear svmStruct;
                                class = cast(class,'double'); clear pc_te_data;

                                % Caso 0 -> Negative
                                if inner_test_label == 0 && class == 0
                                    optim__acc(outerk, innerk, numvar, bc) = ...
                                        optim__acc(outerk, innerk, numvar, bc) + ...
                                        (1/inner_P_test);
                                    optim__spe(outerk, innerk, numvar, bc) = ...
                                        optim__spe(outerk, innerk, numvar, bc) + ...
                                        (1/NNeg);
                                end

                                % Caso 1 -> Positive
                                if inner_test_label == 1 && class == 1
                                    optim__acc(outerk, innerk, numvar, bc) = ...
                                        optim__acc(outerk, innerk, numvar, bc) + ...
                                        (1/inner_P_test);
                                    optim__sen(outerk, innerk, numvar, bc) = ...
                                        optim__sen(outerk, innerk, numvar, bc) + ...
                                        (1/NPos);
                                end                    
                           catch exception
                               disp('Error testing');
                               msgString = getReport(exception)
                           end
                        end

                    end
                    end
                    clear te_data
                end

            catch exception
                % disp('Error training');
                msgString = getReport(exception)
            end
        end % innerk
    end % outerk

    save(['temp/optimal_configurations/performance' '/' ...
        GROUP_0 '_' GROUP_1 '.mat'], 'optim__acc');

    %
    %
    %
    %
    %
    % TESTING
    % Performance evaluation
    %
    %
    %
    %
    %
    load([fullfile('temp/optimal_configurations/performance')...
        '/' GROUP_0 '_' GROUP_1 '.mat']);

    % Re-loading
        % Restore data from the first part of the script
        data0 = freeze.data0;
        N0 = freeze.N0;
        data1 = freeze.data1;
        N1 = freeze.N1;
        clear freeze

        % Train-data matrix + labels'
        data0 = double(data0);
        data1 = double(data1);
        train_data = double([data0; data1]); clear data0; clear data1;
        train_labels = [zeros(1,N0) ones(1,N1)]; 
        original_indices = 1:(N0+N1);

    for outerk = 1:K
        for innerk = 1:K      

            % Searching for the maximum performance
            temp__optimAcc = squeeze(optim__acc(outerk,innerk,:,:));
            [m1, row__index] = max(temp__optimAcc);
            [m2, col__index] = max(m1);
            row__index = row__index(col__index);
            opdim(outerk,innerk).comp = row__index; % number of variables
            opdim(outerk,innerk).bc = col__index; % box constraint

            % Outer-loop setting
            outer_train_set = true(1,size(train_data,1));
            outer_train_set(cv.indices_outerloop==outerk) = false;
            outer_test_set =~outer_train_set;

            outer_train_labels = train_labels(outer_train_set);
            outer_test_labels = train_labels(outer_test_set);

            outer_train_data = train_data(outer_train_set,:,:,:);
            outer_test_data = train_data(outer_test_set,:,:,:);

            outer_train_indices = original_indices(outer_train_set);
            outer_test_indices = original_indices(outer_test_set);

            NNeg = sum(outer_test_labels == 0);
            NPos = sum(outer_test_labels == 1); 

            % Inner-loop settings
            inner_test_indices = outer_train_indices...
                (1,cv.indices_innerloop{outerk} == innerk);
            inner_train_indices = setdiff(outer_train_indices,...
                inner_test_indices);

            inner_train_labels = train_labels(inner_train_indices);
            inner_test_labels = train_labels(inner_test_indices);

            inner_train_data = train_data(inner_train_indices,:);
            inner_test_data = train_data(inner_test_indices,:);       

            inner_P_train = size(inner_train_data, 1);
            inner_Pfeat_train = size(inner_train_data, 2);
            num__variables = min(inner_P_train, inner_Pfeat_train) - 1;
            inner_P_test = size(inner_test_data,1);

            % Preprocessing: Training data         
            tr_data = inner_train_data;

            % FDR
            [tr_data, params(outerk,innerk).featextraction, ~, ~] = ...
                fdrranking(tr_data(:,:), ...
                inner_train_labels', []);         

            pc_tr_data = ...
                tr_data(:, 1:opdim(outerk,innerk).comp); ...
                clear tr_data inner_train_data

            ordered__features = params(outerk,innerk).featextraction;
            params(outerk,innerk).selectedfeatures = ...
                squeeze(ordered__features(1:opdim(outerk,innerk).comp));

            temp__model = ...
                fitcsvm(pc_tr_data, inner_train_labels, ...
                'KernelFunction', kernel, 'Standardize', true, ...
                'BoxConstraint', box__constraint(col__index));
            temp__model = compact(temp__model);

            params(outerk,innerk).model = fitPosterior(temp__model,...
                pc_tr_data, inner_train_labels);

            for subject = 1:size(outer_test_data,1)
                
                % Testing data
                outer_test = outer_test_data(subject,:,:,:);
                outer_test_label = outer_test_labels(subject);

                % Preprocessing: validation data
                te_data = outer_test;

                % FDR
                te_data = te_data(params(outerk,innerk).featextraction);
                pc_te_data = squeeze(te_data(:,1:opdim(outerk,innerk).comp));

                % Classification
                [class, postprob] = ...
                    predict(params(outerk,innerk).model, pc_te_data);
                class = cast(class','double');

                if ~exist('scores','var')
                    target = zeros(1,size(outer_test_data,1));
                    scores = zeros(K,size(outer_test_data,1));
                    svm__postprob = zeros(K,size(outer_test_data,1));
                end
                target(1,subject) = outer_test_label;
                scores(innerk,subject) = class;
                svm__postprob(innerk,subject) = postprob(1);

                clear pc_te_data
            end

            clear pc_tr_data
        end

        innerk__scores = round(mean(scores, 1)); clear scores
        innerk__svmpprob = mean(svm__postprob, 1);
        innerk__scores = mean(svm__postprob, 1) < 0.5; clear svm__postprob

        cp__temp = classperf(squeeze(target(1,:)), innerk__scores);
        nestedcv__acc(outerk,1) = cp__temp.CorrectRate;
        nestedcv__sen(outerk,1) = cp__temp.Sensitivity;
        nestedcv__spe(outerk,1) = cp__temp.Specificity;

        % Compute/assign global target, global scores and global prob
            if ~exist('global__target','var')
                global__target = squeeze(target(1,:));
            else
                global__target = [global__target squeeze(target(1,:))];
            end
            clear target

            if ~exist('global__scores','var')
                global__scores = innerk__scores;
            else
                global__scores = [global__scores innerk__scores];
            end

            if ~exist('global__svmpprob','var')
                global__svmpprob = innerk__svmpprob;
            else
                global__svmpprob = [global__svmpprob innerk__svmpprob];
            end        

    end

    acc = mean(nestedcv__acc); err__acc = std(nestedcv__acc);
    sen = mean(nestedcv__sen); err__sen = std(nestedcv__sen);
    spe = mean(nestedcv__spe); err__spe = std(nestedcv__spe);
    cp = classperf(global__target, global__scores);
    acc = cp.CorrectRate;
    sen = cp.Sensitivity;
    spe = cp.Specificity;

    [~, ~, ~, auc] = perfcurve(global__target, ...
    global__svmpprob, '0');

    date__str = datestr(now,'yyyymmdd-HHMM');
    model__path = [date__str '__model.mat'];

    status.accuracy = acc; status.accuracy__std = err__acc;
    status.sensitivity = sen; status.sensitivity__std = err__sen;
    status.specificity = spe; status.specificity__std = err__spe;
    status.scores = global__scores;
    status.target = global__target;
    status.svmpprob = global__svmpprob;
    status.date__str = date__str;
    status.model__path = model__path;
    status.sbjs = sbjs;
    status.cp = cp;

    % Feature importance
    feature__counter = zeros(1, size(data, 2));
    unit = 1 / (size(params, 1) * size(params, 2));
    for ii = 1:size(params, 1)
        for jj = 1:size(params, 2)
            sel = params(ii, jj).selectedfeatures;
            for kk = 1:size(sel, 2)
               feature__counter(1, sel(kk)) = feature__counter(1, sel(kk)) + unit;
            end
        end
    end
    
    results(iterations).cp = cp;
    results(iterations).feature__counter = feature__counter;
    results(iterations).status = status;
    results(iterations).auc = auc;
    
    clearvars -except params results
    
    rmdir 'temp' s

end

acc = [];
sen = [];
spe = [];
auc = [];
feat__counter = [];
for i = 1:size(results, 2)
    acc = [acc; results(i).cp.CorrectRate];
    sen = [sen; results(i).cp.Sensitivity];
    spe = [spe; results(i).cp.Specificity];
    auc = [auc; results(i).auc];
    feat__counter = [feat__counter; results(i).feature__counter];
end

disp('.');
disp('.');
disp('.');
disp('Results');
disp('-----');
disp(['Accuracy: ' num2str(mean(acc)) ' +/- ' num2str(std(acc))]);
disp(['Sensitivity: ' num2str(mean(sen)) ' +/- ' num2str(std(sen))]);
disp(['Specificity: ' num2str(mean(spe)) ' +/- ' num2str(std(spe))]);
disp(['AUC: ' num2str(mean(auc)) ' +/- ' num2str(std(auc))]);
