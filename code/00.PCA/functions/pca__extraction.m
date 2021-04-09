% Performs PCA transformation to data. Extracts k principal components 
% according to the method proposed in  EIGENFACES FOR RECOGNITION. Turk and
% Pentland. Journal of Cognitive Neuroscience 3,(1).
%
% Columns of data: k-length projected data (PCA coefficients)

function [pca_data, parameters] = pca__extraction(data, k)

if isempty(k)
    k = min(size(data, 1), size(data, 2)) - 1;
end

[Obs] = size(data,1);                                                       % Rows of data correspond to observations

data_mean = mean(data,1);
datazm = data - repmat(data_mean,Obs,1);
L = datazm * datazm';
[V, D] = eigs(L,k);                                                         % Columnas de V, autovectores de L
U = V' * datazm;
pca_data = (U * datazm')';

parameters.data_mean = data_mean;
parameters.U = U;
parameters.Obs = Obs;
% parameters.V = V;
% parameters.D = D;

%
% New version of pca__extraction (by 2020-02-26) using the Matlab built-in
% function pca()
%
% coeff = pca(X) returns the principal component coefficients, also known
% as loadings, for the n-by-p data matrix X. Rows of X correspond to
% observations and columns correspond to variables. The coefficient matrix
% is p-by-p. Each column of coeff contains coefficients for one principal
% component, and the columns are in descending order of component variance.
% By default, pca centers the data and uses the singular value
% decomposition (SVD) algorithm.
%
% The variable "pca_data" correspond to the output "score" of the Matlab
% function. 
% The variable "data_mean" correspond to the output "mu" of the Matlab
% function. 
%
% [coeff, score, latent, tsquared, explained, mu] = pca(data);
% 
% pca_data = score;
% parameters.data_mean = mu;
% parameters.U = coeff;
% parameters.Obs = Obs;
% parameters.latent = latent;
