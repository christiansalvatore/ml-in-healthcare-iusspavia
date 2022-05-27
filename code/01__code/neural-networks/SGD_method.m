function Weight = SGD_method(Weight, Bias, input, correct_Output)
                                                                            % Input 3 neurons
                                                                                
    LR = 0.25;

    N = size(input,2);

    for k=1:N

        transposed_Input = input(k, :)';
        expected = correct_Output(k);
        lin_comb = Weight * transposed_Input + Bias;
        predicted = Sigmoid(lin_comb);

        cost_function = (expected - predicted)^2;
        delta = 2 * predicted * (1-predicted) * cost_function;              % Delta is derivate of sigmoid*cost_function 
                                                                            % Derivate of the sigmoid is sigmoid*(1-sigmoid)

        dWeight = LR * delta * transposed_Input;                            % dWeigth = LR*derivate(cost_function) = LR*(delta*input)
                                                                            % Weight correction given by learning rate
                                                                            % Multiplied by delta and the transposed input
                                                                            
        dBias = LR * delta;
        
        Weight = Weight + dWeight';
        Bias = Bias + dBias';
        
    end
end