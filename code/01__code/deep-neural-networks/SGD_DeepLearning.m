function [w1,w2,w3,w4] = SGD_DeepLearning(w1,w2,w3,w4,input, correct_Output)
    LR = 0.01;                                                                     %set parameters for adjustment of weights
    N = 5;
    for k = 1:N                                                                 %start cycle for training (N is the number of input matrices for training)
        reshaped_input_Image = input(k,:);                                      %convert k matrix into array
        input_of_hidden_layer1 = w1*reshaped_input_Image';                       %first hidden layer
        output_of_hidden_layer1 = ReLU(input_of_hidden_layer1);                 
        input_of_hidden_layer2 = w2*output_of_hidden_layer1;                    %second hidden layer
        output_of_hidden_layer2 = ReLU(input_of_hidden_layer2);
        input_of_hidden_layer3 = w3*output_of_hidden_layer2;                    %third hidden layer
        output_of_hidden_layer3 = ReLU(input_of_hidden_layer3);
        input_of_output_node = w4*output_of_hidden_layer3;                      %output layer
        predicted = Softmax(input_of_output_node);
        
        expected = correct_Output(k,:)';
        cost_function = expected - predicted;                                   %error in classification
        
        delta = cost_function;                                                  % delta is derivate of Softmax*cost_function = 1*cost_function
        d_weight4 = LR*delta*output_of_hidden_layer3';                          % al posto di input4 ho output3 perche'ho la RELU di mezzo
        
        cost_function3 = w4'*delta;                                             %back-propagation to correct weights
        delta3 = (input_of_hidden_layer3>0).*cost_function3;
        d_weight3 = LR*delta3*output_of_hidden_layer2';
         
        cost_function2 = w3'*delta3;
        delta2 = (input_of_hidden_layer2>0).*cost_function2;
        d_weight2 = LR*delta2*output_of_hidden_layer1';
        
        cost_function1 = w2'*delta2;
        delta1 = (input_of_hidden_layer1>0).*cost_function1;  
        d_weight1 = LR*delta1*reshaped_input_Image;
        
        w1 = w1+d_weight1;                                               
        w2 = w2+d_weight2;
        w3 = w3+d_weight3;
        w4 = w4+d_weight4;
    end
end