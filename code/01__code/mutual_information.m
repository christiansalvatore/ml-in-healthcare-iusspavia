function mutualinfo = mutual_information(indata)

    for i = 1:size(indata,2)
        for j = 1:size(indata,2)
            if i < j
                mutualinfo(i,j) = compute_mutualinfo(indata(:,i), indata(:,j));
            else
                mutualinfo(i,j) = NaN;
            end
        end
    end

end

function out = compute_mutualinfo(in1, in2)

    % Entropy
    count = hist3([in1 in2]); % Count the values
    jointprob = count/sum(sum(count)); % Divide by the sum on all matrix value to get probability

    mrg = repmat(sum(jointprob,2), [1, size(jointprob,1)]);
    idx = (jointprob(:) > 0 & mrg(:) > 0);
    condentropy_1_2 = sum( jointprob(idx) .* log2( mrg(idx) ./ jointprob(idx) ));

    entropy_1 = -nansum(sum(jointprob,2).*log2(sum(jointprob,2)));

    out = entropy_1 - condentropy_1_2;

end
