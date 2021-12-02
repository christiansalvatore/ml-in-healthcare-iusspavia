function [data, label] = loading__fromexcel()

    filename = 'data__clean__exercise.xlsx';

    % Load data
    m = readmatrix(filename);
    
    % Otherwise -> load data using the 'cell' format to preserve strings
    % c = readcell(filename);

    data = squeeze(m(:, [3:15])); % data = squeeze(m(:, [4 5 6 11 13]));
    label = squeeze(m(:, 16));
    
    % Exclude samples with 'NaN' entries
    logical__index = true(size(data,1), 1);
    check = isnan(data);
    for r = 1:size(data, 1)
        if length(unique(check(r, :))) ~= 1
            logical__index(r, 1) = false;
        end
    end
    data = data(logical__index, :);
    label = label(logical__index, :);
    
end