function [obj, maskim] = mask(obj,maskim)
%MASK Select spatial points using a mask image
% mask(maskim) returns a Cube containing the pixels determined
% by the logical matrix maskim in columnwise order.
% The matrix maskim must have the same spatial dimensions as the
% Cube.

assert(islogical(maskim), ...
    'Cube:InvalidMaskType', 'The mask must be a logical matrix.');
assert(isequal(size(maskim), [obj.Height,obj.Width]),...
    'Cube:InvalidMaskShape', ...
    'The mask must have the same dimensions as the Cube ([%d %d]), was %s',...
    obj.Height, obj.Width, mat2str(size(maskim)));

% Count the number of spatial pixels after masking
N = sum(maskim(:));

% Replicate the mask bandwise for easy indexing
cubeMask = repmat(maskim,1,1,obj.nBands);

% Index the data using the mask and reshape into columnwise
% gathered spectral vectors.
obj.Data    = reshape(obj.Data(cubeMask),N,1,obj.nBands);
obj.History = {{'Spatial mask applied',@mask, maskim}};
end