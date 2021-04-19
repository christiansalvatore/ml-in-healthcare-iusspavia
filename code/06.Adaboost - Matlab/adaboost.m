
function adaboost

x = [0.1 0.2; ...
    0.09 0.55; ...
    0.30 0.8; ...
    0.60 0.95; ...
    0.75 0.75; ...
    0.20 0.1; ...
    0.22 0.58; ...
    0.60 0.50; ...
    0.90 0.8; ...
    0.90 0.2];

y = [ 1 1 1 1 1 0 0 0 0 0]';

T = 3;
%MAKE SOME PRETEND CLASSIFIERS
weakClassifierMistakes(:,1) = [ 0 0 1 1 1 0 0 0 0 0 ]';
weakClassifierMistakes(:,2) = [ 0 0 0 0 0 1 1 1 0 0 ]';
weakClassifierMistakes(:,3) = [ 1 1 0 0 0 0 0 0 1 0 ]';


%DEFINE UNIFORM DISTRIBUTION
D = zeros(10,T);
D(:,1) = ones(10,1)/10;

disp('-----------------------------');
disp('Begin Adaboost update demo');
disp('-----------------------------');
disp('ROUND t=1')
disp('-----------------------------');
disp('Initial distribution D_1:');
disp(D(:,1)');

for t=1:3
   
    replotDataset(D,t);
    
    if (t>1)
        disp('-----------------------------');
        disp(['ROUND t=' num2str(t) ]);
        disp('-----------------------------');
    end
    
    %GET A WEAK CLASSIFIER
    herrors = weakClassifierMistakes(:,t);
    epsilon(t) = sum(D(:,t).*herrors);
    
    %PLOT ITS ERRORS
    disp(['Weak learner h_' num2str(t) ' makes errors on examples: ' num2str(find(weakClassifierMistakes(:,t))') ]);
    disp(['So h_' num2str(t) ' has weighted error: ' num2str(epsilon(t)) ]);
    disp('Press a key to continue...');
    pause
    replotDataset(D,t);
    scatter(x(herrors==1,1),x(herrors==1,2), 1000, 'go');
    
    %UPDATE
    D(:,t+1) =  reweight(D(:,t),epsilon(t),herrors);
    
    disp(['New distribution D_' num2str(t+1) ]);
    disp(D(:,t+1)');
    disp('Press a key to continue...');
    pause
    
    disp(' ');    
    disp(' ');
    
end


D
epsilon
alpha = 0.5*log((1-epsilon)./epsilon)

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function D =  reweight(D,epsil,herrors)

%REWEIGHT
D((herrors==1)) = D((herrors==1))./(2*epsil);
D((herrors==0)) = D((herrors==0))./(2*(1-epsil));


%RENORMALIZE
D = D./sum(D);

end


%%%%%%%%%%%%%%%%%%%%%%%%%

function replotDataset(D,t)

x = [0.1 0.2; ...
    0.09 0.55; ...
    0.30 0.8; ...
    0.60 0.95; ...
    0.75 0.75; ...
    0.20 0.1; ...
    0.22 0.58; ...
    0.60 0.50; ...
    0.90 0.8; ...
    0.90 0.2];

y = [ 1 1 1 1 1 0 0 0 0 0]';

close;

sizes = 5000*D(:,t);

scatter(x(y==1,1),x(y==1,2), sizes(y==1), 'b+');
hold on
scatter(x(y==0,1),x(y==0,2), sizes(y==0), 'rs');

for i=1:length(y)
    text(x(i,1)+0.03,x(i,2)+0.03,num2str(i),'FontSize',15);
end


axis([0 1 0 1]); axis square;
set(gca,'XTick',[]);
set(gca,'YTick',[])
box


end
