function [obj, maskim] = unmask(obj,maskim)
%UNMASK Spatially reshape columnwise ordered spectra
% unmask(maskim) attempts to reorganize the Cube data into
% a Cube with the spatial dimensions of the mask image, with
% the true values in the mask containing the data and the
% rest initialized to zero.
% 
% The matrix maskim must be a logical matrix with the amount of
% true elements equal to the number of pixels in the Cube.

assert(islogical(maskim), 'Cube:InvalidMaskType', 'The mask must be a logical matrix.');
% scalars are accepted for the edge case of a single pixel
assert(ismatrix(maskim) || isscalar(maskim), 'Cube:InvalidMaskShape', 'The mask must be a logical matrix.');

% Calculate the number of spatial pixels and check for sanity
N = sum(maskim(:));

assert(N == obj.Area,...
    'Cube:InvalidMaskArea', ...
    'The number of nonempty pixels in the mask (%d) does not equal the number of existing pixels (%d)',...
    N,obj.Area);

% Replicate the mask for each band for easy indexing
cubeMask = repmat(maskim,1,1,obj.nBands);

% Initialize the new data with zero and assign the values to
% the mask positions
tmp           = zeros(size(cubeMask), obj.Type);
tmp(cubeMask) = obj.Data(:);
obj.Data      = tmp;
obj.History   = {{'Reshaped using a mask image', @unmask, maskim}};

end