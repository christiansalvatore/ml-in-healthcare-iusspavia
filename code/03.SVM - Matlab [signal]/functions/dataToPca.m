% Peform PCA transformation to data. Extracts k principal components 
% according to the method proposed in  EIGENFACES FOR RECOGNITION. Turk and
% Pentland. Journal of Cognitive Neuroscienc 3,(1).
%
% Subtract the mean to the test samples and project them onto the PCA axes

function FinalData = dataToPca (data, U, data_mean, Ntst)

RowDataAdjust = data - repmat(data_mean,Ntst,1);
FinalData = (U * RowDataAdjust')';