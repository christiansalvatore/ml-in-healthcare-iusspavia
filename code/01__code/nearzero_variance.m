function out = nearzero_variance(indata)

    nearzerovariance_logical = false(1, size(indata,2));
   
    % Check the frequency of uniqueness | Condition #1
    for i = 1:size(indata, 2)
        unique_(i) = 100 * size(unique(indata(:,i)),1) / size(indata,1);
    end
    
    % Check the ratio | Condition #2
    for j = 1:size(indata, 2)
        count_ = histcounts(indata(:,j), unique(indata(:,j)));
        counts_ = sort(count_, 'descend');
        ratio_(j) = counts_(1) / counts_(2);
        clear count_ counts_
    end
    
    for k = 1:size(indata, 2)
        if unique_(k) < 10 && ratio_(k) > 20
            nearzerovariance_logical(k) = true;
        end
    end

    out = nearzerovariance_logical;
    
end
