load('DeepNeuralNetwork.mat');                                                          %load trained deep neural network

input_Image_test(:,:,1) = [1 0 0 1 1; 1 1 0 1 1; 1 1 0 1 1; 1 1 0 1 1; 1 0 0 0 1];      %input matrix for testing

reshaped_input_Image = reshape(input_Image_test, 25, 1);                                    %reshape matrix


input_of_hidden_layer1 = w1*reshaped_input_Image;                                       %pass the matrix through the network
output_of_hidden_layer1 = ReLU(input_of_hidden_layer1);
input_of_hidden_layer2 = w2*output_of_hidden_layer1;
output_of_hidden_layer2 = ReLU(input_of_hidden_layer2);
input_of_hidden_layer3 = w3*output_of_hidden_layer2;
output_of_hidden_layer3 = ReLU(input_of_hidden_layer3);
input_of_output_node = w4*output_of_hidden_layer3;
final_output = Softmax(input_of_output_node)                                            %get classification of input matrix