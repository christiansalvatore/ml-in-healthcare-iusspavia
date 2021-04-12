function volume__output = imagepreprocessing(volume__input)
%IMAGEPREPROCESSING performs a set of processing operations to the input
%volume (3D) and it returns a single slice (2D) to be plotted in a figure

% Normalization
volume__output = volume__input - min(min(min(volume__input)));
volume__output = volume__output*(1/max(max(max(volume__input))));
end

