%-------------------------------------------------------------------------
% Practical session | #pca #nifti #mri #eigenbrains
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% 1. Inizialization
%-------------------------------------------------------------------------
clear; clc; close all;
% Locate your data path
data_path = uigetdir();
data_path = [data_path '\'];
addpath(genpath(data_path));
addpath(genpath('functions'));

% Create a log file
diary('log.txt');
diary on


%-------------------------------------------------------------------------
% 2. Working with NIfTI images
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% 2.1 Loading and visualizing a single NIfTI image
%-------------------------------------------------------------------------
% Remove unnecessary variables before implementing the next task, but
% keep/preserve the variables of interes (if present)
% Tip: in order to preserve some variables of interest, use
% "clearvars -except name-of-the-variable"
close all
clearvars -except data_path

gm = load_nii([data_path 'single-patient/MRI/mwp1-mri.nii']);

% Read the header of the loaded image
hdr = gm.hdr;
hdr.hk
hdr.dime
hdr.hist

% Read and visualize the image
% Tip: use the function "squeeze"
gm = gm.img;
gm = double(gm);
selectedslice = squeeze(gm(:,:,50));

% "Fix" the visualization based on the output/color scale
minimum = min(min(selectedslice)); disp(num2str(minimum));
maximum = max(max(selectedslice)); disp(num2str(maximum));

% Normalize the image between 0 and 1
selectedslice = selectedslice - minimum;
disp(num2str(max(max(selectedslice))));
selectedslice = selectedslice/maximum;
selectedslice = selectedslice*1;

% Create a new figure
figuragm = figure();

% Plot the image on the current figure
imshow(selectedslice,[]);

% Visualize the colorbar
colorbar

% Rotate the image
selectedslice = rot90(selectedslice);
imshow(selectedslice,[]);
colorbar

% Change the colormap
imshow(selectedslice,[],'Colormap',hot);
imshow(selectedslice,[],'Colormap',winter);
imshow(selectedslice,[],'Colormap',spring);
imshow(selectedslice,[],'Colormap',summer);
imshow(selectedslice,[],'Colormap',gray);

% Title
set(gcf, 'Name', 'Gray Matter', 'NumberTitle', 'On');

% Alternatives: image(); imagesc();


%-------------------------------------------------------------------------
% 2.2 Visualizing multiple images on the same figure (multiple plot)
%     Tip: use the command "subplot"
%-------------------------------------------------------------------------
clearvars -except data_path
close all

% Load the single images: Gray Matter, White Matter and Whole Brain
gm = load_nii([data_path 'single-patient/MRI/mwp1-mri.nii']);
wm = load_nii([data_path 'single-patient/MRI/mwp2-mri.nii']);
wb = load_nii([data_path 'single-patient/MRI/wm-mri.nii']);

gm = double(gm.img);
wm = double(wm.img);
wb = double(wb.img);

% Intensity normalization
gm = gm - min(min(min(gm)));
gm = gm*(1/max(max(max(gm))));

wm = wm - min(min(min(wm)));
wm = wm*(1/max(max(max(wm))));

wb = wb - min(min(min(wb)));
wb = wb*(1/max(max(max(wb))));

% Squeeze
gmselectedslice = squeeze(gm(:,:,50));
wmselectedslice = squeeze(wm(:,:,50));
wbselectedslice = squeeze(wb(:,:,50));

% Rotation
gmselectedslice = rot90(gmselectedslice);
wmselectedslice = rot90(wmselectedslice);
wbselectedslice = rot90(wbselectedslice);

% Multiple plot
figure();
hold on;
subplot(1,3,1); imshow(gmselectedslice,[]);
subplot(1,3,2); imshow(wmselectedslice,[]);
subplot(1,3,3); imshow(wbselectedslice,[]);
colormap(gray);


%-------------------------------------------------------------------------
% 2.3 Reconstructing the whole brain starting from gray-matter and
% white-matter volumes
%-------------------------------------------------------------------------
clearvars -except gm wm wb data_path
wb__reconstructed = gm + wm;

gm = imagepreprocessing(gm);
wm = imagepreprocessing(wm);
wb = imagepreprocessing(wb);
wb__reconstructed = imagepreprocessing(wb__reconstructed);

figure();
hold on;
colormap(gray)
subplot(1,4,1); imshow(sliceextraction(gm),[]);
subplot(1,4,2); imshow(sliceextraction(wm),[]);
subplot(1,4,3); imshow(sliceextraction(wb),[]);
subplot(1,4,4); imshow(sliceextraction(wb__reconstructed),[]);

%-------------------------------------------------------------------------
% 2.4 Application of filters and elaboration/processing of 3-dimensional
%     images: smoothing
%-------------------------------------------------------------------------
clearvars -except gm data_path
close all

% Smoothing filtering
% Tip: use the "imgaussfilt" command
figura__multipla = figure();
hold on;
colormap(gray);

gm__orig = imagepreprocessing(gm);
subplot(2,3,1); imshow(sliceextraction(gm__orig),[]);

gm__smo2 = imgaussfilt(gm,2);
gm__smo2 = imagepreprocessing(gm__smo2);
subplot(2,3,2); imshow(sliceextraction(gm__smo2),[]);

gm__smo4 = imgaussfilt(gm,4);
gm__smo4 = imagepreprocessing(gm__smo4);
subplot(2,3,3); imshow(sliceextraction(gm__smo4),[]);

gm__smo6 = imgaussfilt(gm,6);
gm__smo6 = imagepreprocessing(gm__smo6);
subplot(2,3,4); imshow(sliceextraction(gm__smo6),[]);

gm__smo8 = imgaussfilt(gm,8);
gm__smo8 = imagepreprocessing(gm__smo8);
subplot(2,3,5); imshow(sliceextraction(gm__smo8),[]);

gm__smo10 = imgaussfilt(gm,10);
gm__smo10 = imagepreprocessing(gm__smo10);
subplot(2,3,6); imshow(sliceextraction(gm__smo10),[]);


%-------------------------------------------------------------------------
% 3. Working with multiple images (multiple patients)
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% 3.1 Loading the images from a folder
%     Images can be found in the 'data/multiple-patients/MRI/' folder
%     Tip: use the function "dir"
%-------------------------------------------------------------------------

path = [data_path 'multiple-patients/MRI/'];
files = dir(fullfile([path '*.nii']));
for n = 1:size(files,1)
    pathtemp = [path files(n).name];
    nii = load_nii(pathtemp);
    img = double(nii.img);
    stackimg(n,:,:,:) = img;
    disp(['The dimension of stackimg after ' num2str(n)...
        ' iterations is ' num2str(size(stackimg))]);
end
nvoxel = size(stackimg,2) * size(stackimg,3) * size(stackimg,4);
disp(['Each of the ' num2str(size(stackimg,1))...
    ' loaded images is made of ' num2str(nvoxel) ' voxels']);

% Create a single volume, resulting from the mean of the images
% loaded in the previous point. Visualize the resulting image.
meanimg = mean(stackimg,1);
meanimg = squeeze(meanimg(1,:,:,:));
meanimg = imagepreprocessing(meanimg);
figure();
imshow(sliceextraction(meanimg),[]);

% Montage
meanimg__reshape = reshape(meanimg,[size(meanimg,1),size(meanimg,2),1,...
    size(meanimg,3)]);
montage(rot90(meanimg__reshape));

% Visualize specific slices
montage(rot90(meanimg__reshape),'Indices',51:80,'Size',[3 10]);

% Visualize a specific range of intensities
montage(rot90(meanimg__reshape),'Indices',51:80,'Size',[3 10],...
    'displayRange',[0.25 0.5]);


%-------------------------------------------------------------------------
% 4. Clear
%-------------------------------------------------------------------------

% Interrupt the input to the log file
close all
clearvars -except stackimg
clc
diary off

%-------------------------------------------------------------------------
% 4. PCA
%-------------------------------------------------------------------------

% Reshape MRI volumes (LINEARIZATION)
for i = 1:5
    temp(i, :) = reshape(stackimg(i,:,:,:), [1,121*145*121]);
end

%Choose how many Principal Components to extract (try and change this
%value)
k = 3;

% Extract PCA
[pca_data, parameters] = pca__extraction(temp, k);

% Backprojection from PCA space to original image space
original__data = pca2data(pca_data, parameters.U, parameters.data_mean, parameters.Obs);
original__data = original__data';
original__data = reshape(original__data, [5,121,145,121]);

% Re-normalize image intensities for visualization
for i = 1:5
    max_now = max(max(max(original__data(i,:,:,:))));
    min_now = min(min(min(original__data(i,:,:,:))));
    original__data(i,:,:,:) = (original__data(i,:,:,:)-min_now)/(max_now-min_now);
end

% Visualize specific slices
sample = 1;
first_slice = 51;
last_slice = 80;
montage(rot90(squeeze(original__data(sample,:,:,:))), ...
    'Indices',first_slice:last_slice,'Size',[3 10]);
