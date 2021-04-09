% Peform PCA transformation to data. Extracts k principal components 
% according to the method proposed in  EIGENFACES FOR RECOGNITION. Turk and
% Pentland. Journal of Cognitive Neuroscienc 3,(1).
%
% Columns of pca_dta: k-length projected data (PCA coefficients)

function [pca_data, data_mean, U, Obs] = pca(data, k)

[Obs] = size(data,1);
data_mean = mean(data,1);
datazm = data - repmat(data_mean,Obs,1);
L = datazm * datazm';
[V, D] = eigs(L,k); % Columns of V, eigenvectors of L
U = V' * datazm;
pca_data = (U * datazm')';

