input_Image = zeros(5,5,5);                                                         %set input matrices
input_Image(:,:,1) = [1 0 0 1 1;
                      1 1 0 1 1;
                      1 1 0 1 1;
                      1 1 0 1 1;
                      1 0 0 0 1];                                                   %each element of the matrix is a feature

input_Image(:,:,2) = [0 0 0 0 1;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      0 1 1 1 1;
                      0 0 0 0 0];
                  
input_Image(:,:,3) = [0 0 0 0 1;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      1 1 1 1 0;
                      0 0 0 0 1];
                  
input_Image(:,:,4) = [0 1 1 1 0;
                      0 1 1 1 0;
                      1 0 0 0 0;
                      1 1 1 1 0;
                      1 1 1 1 0];

input_Image(:,:,5) = [0 0 0 0 0;
                      0 1 1 1 1;
                      0 0 0 0 1;
                      1 1 1 1 0;
                      0 0 0 0 1];

correct_Output = [1 0 0 0 0;
                  0 1 0 0 0;
                  0 0 1 0 0;
                  0 0 0 1 0;
                  0 0 0 0 1];                                                       %set matrix of correct output,
                                                                                    %size (number of inputs)*(number of classes)
                                                                                    
w1 = 2*rand(20,25)-1;                                                               %initialise 4 weights,
w2 = 2*rand(20,20)-1;                                                               %sizes depend on the sizes of input matrices (e.g. 25)
w3 = 2*rand(20,20)-1;                                                               %and number of classes (e.g. 5)
w4 = 2*rand(5,20)-1;

for epoch = 1: 10000                                                                %start training cycle
    [w1, w2, w3, w4] = SGD_DeepLearning(w1, w2, w3, w4, input_Image, correct_Output);
end
save('DeepNeuralNetwork.mat');                                                      %save trained deep neural network

%
%
%

input_Image = zeros(5,5,5);                                                         %set input matrices
input_Image(:,:,1) = [1 0 0 1 1;
                      1 1 0 1 1;
                      1 1 0 1 1;
                      1 1 0 1 1;
                      1 0 0 0 1];                                                   %each element of the matrix is a feature

input_Image(:,:,2) = [0 0 0 0 1;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      0 1 1 1 1;
                      0 0 0 0 0];
                  
input_Image(:,:,3) = [0 0 0 0 1;
                      1 1 1 1 0;
                      1 0 0 0 1;
                      1 1 1 1 0;
                      0 0 0 0 1];
                  
input_Image(:,:,4) = [0 1 1 1 0;
                      0 1 1 1 0;
                      1 0 0 0 0;
                      1 1 1 1 0;
                      1 1 1 1 0];

input_Image(:,:,5) = [0 0 0 0 0;
                      0 1 1 1 1;
                      0 0 0 0 1;
                      1 1 1 1 0;
                      0 0 0 0 1];

correct_Output = [1 0;
                  0 1;
                  1 0;
                  1 0;
                  1 0];                                                       %set matrix of correct output,
                                                                                    %size (number of inputs)*(number of classes)
                                                                                    
w1 = 2*rand(20,25)-1;                                                               %initialise 4 weights,
w2 = 2*rand(20,20)-1;                                                               %sizes depend on the sizes of input matrices (e.g. 25)
w3 = 2*rand(20,20)-1;                                                               %and number of classes (e.g. 5)
w4 = 2*rand(2,20)-1;

for epoch = 1: 10000                                                                %start training cycle
    [w1, w2, w3, w4] = SGD_DeepLearning(w1, w2, w3, w4, input_Image, correct_Output);
end
save('DeepNeuralNetwork.mat');                                                      %save trained deep neural network

%
%
%

input = binary_data;

correct_Output = double([binary_labels==1 binary_labels==2]);

w1 = 2*rand(20,12)-1;                                                               %initialise 4 weights,
w2 = 2*rand(20,20)-1;                                                               %sizes depend on the sizes of input matrices (e.g. 25)
w3 = 2*rand(20,20)-1;                                                               %and number of classes (e.g. 5)
w4 = 2*rand(2,20)-1;

for epoch = 1: 10000                                                                %start training cycle
    [w1, w2, w3, w4] = SGD_DeepLearning(w1, w2, w3, w4, input, correct_Output);
end
save('DeepNeuralNetwork.mat');                                                      %save trained deep neural network