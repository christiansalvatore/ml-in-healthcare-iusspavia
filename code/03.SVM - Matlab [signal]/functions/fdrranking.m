function [outputdata, index, fdr, unranked__fdr] = fdrranking(inputdata, labels, m)
% 
% Rearranges the variables in decreasing order according to the 
% Fisher Discriminant Ratio (FDR)
% 
% NOTE: inputdata = observations x variables
% 
% INPUT
%     inputdata: PxN matrix of data. P represents the number of
%     observations and N the number of variables.
%     labels: binary Px1 vector containing associated labels for each
%     observation in inputdata. Labels are usually assigned as 0 to normal
%     controls and 1 to pathological samples. 
%     m: number of selected variables.
%    
% OUTPUT
%     outputdata: PxM matrix of data, consisting in the same P observations
%     and the M variables with greater FDR.
%     index: Mx1 vector consisting in the index used to rearrange the
%     data.
%     fdr: ranked fdr values.
%     unranked__fdr: unranked fdr values.
%
% Last modified: Annalisa Polidori [2018-04-09]
% Last modified: Christian Salvatore [2018-09-18]

    group0 = find(labels == 0);
    group1 = find(labels ~= 0);
    if isempty(group0) || isempty(group1)
        try
            group0 = find(labels == 1);
            group1 = find(labels ~= 1);
        catch
            disp('Error: at least one of the two classes is empty!');
            return
        end
    end

    % Pre-allocate space for the fdr variable
    fdr = zeros(1,size(inputdata,2));
    
    % Computing the fdr for each variable
    for variable = 1:size(inputdata,2)
        fdr(variable) = fisherdiscriminantratio(inputdata(:,variable), group0, group1, variable);
    end

    % Double check
    fdr(isnan(fdr)) = -1;
    
    unranked__fdr = fdr;
    [fdr, index] = sort(fdr, 'descend');
    
    if isempty(m)
        m = size(inputdata,2);
    end
    index = index(1:m);
    outputdata = inputdata(:,index);

end

function fdr = fisherdiscriminantratio(inputdata, group0, group1, variable)

    m0 = mean(inputdata(group0));
    m1 = mean(inputdata(group1));
    v0 = var(inputdata(group0));
    v1 = var(inputdata(group1));
    if (v0+v1) == 0 && (m0-m1) == 0
        disp(['Warning: both sum of variances and difference of means are zero! FDR will be set to zero by default for variable #' num2str(variable) '.']);
        fdr = 0;
    elseif (v0+v1) == 0 && (m0-m1) ~= 0
        disp(['Warning: sum of variances is zero, but difference of means is not. FDR will be set to 100 by default for variable #' num2str(variable) '.']);
        fdr = 100;
    else
        fdr = (m0-m1)^2/(v0+v1);
    end

end


