function selectedslice = sliceextraction(volume__input)
% Squeeze
selectedslice = squeeze(volume__input(:,:,50));
% Rotation
selectedslice = rot90(selectedslice);
end

