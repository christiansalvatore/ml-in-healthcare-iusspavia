% input = [0 0 1;
%          0 1 1;
%          1 0 1;
%          1 1 1];
% 
% correct_Output = [0
%                   0
%                   1
%                   1];

input = binary_data;
correct_Output = binary_labels;

Weight = 2*rand(1,7) - 1;                                                   % Initial weights
Bias = rand(1);

for epoch = 1:100000
    Weight = SGD_method(Weight, Bias, input, correct_Output);
%     input
%     correct_Output
end
Weight
%save('Trained_Network')