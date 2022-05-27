load('Trained_Network.mat');
input = [0 0 0;
         0 1 1;
         1 0 1;
         1 1 1];
     
N = size(input,1);
for k=1:N
    
       transposed_Input = input(k, :)';
       weighted_Sum = Weight*transposed_Input+Bias;
       p(k) = Sigmoid(weighted_Sum);
       predicted(k) = p(k) > 0.5;
       
end


classperf(correct_Output-1,predicted)