function data = normalization_function(data, normalization_choice)
    if strcmp(normalization_choice,'y')
        disp('Normalization of scores: requested.');
    elseif strcmp(normalization_choice,'n')
        disp('Normalization of scores: not requested.');
    else
        disp('Normalization of scores: z-score normalization.');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Normalizzazione degli scores tra 0 e 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(normalization_choice,'y')
        for c = 1:size(data,2)
            if min(data(:,c)) < 0
                data(:,c) = data(:,c)+abs(min(data(:,c)));
            else
                data(:,c) = data(:,c)-abs(min(data(:,c)));
            end
            data(:,c) = data(:,c)/max(data(:,c));
        end
        max(max(data))
        min(min(data))
        clear c
    elseif strcmp(normalization_choice,'z')
        for c = 1:size(data,2)
            m = mean(squeeze(data(:,c)));
            s = std(squeeze(data(:,c)));
            data(:,c) = (data(:,c)-m)/s;
        end
        clear m s
    end
end
