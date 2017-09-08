function [obj, idx] = bands(obj,b)
%BANDS Return a Cube with selected bands
% Usage:
% c2 = c1.BANDS(b) selects the bands from c1 specified by the vector b.
%
% Valid values for b are
%   - A vector of integers in the range 1:nBands. The result will contain
%     the specified bands in the given order. If an index is supplied
%     multiple times, the result will contain copies of the given band.
%   - A logical vector with length equal to nBands.
% 
% Wavelength and FWHM information will be carried over for the selected
% bands.

% Input validation
assert(isvector(b), ...
    'Cube:InvalidIdxShape', 'Bands must be specified as a row or column vector');
assert(all(Utils.isint(b)),... % Note that this passes for logical indices
    'Cube:InvalidBandIdx', 'Band indices must be logical or integers between %d and %d', 1, obj.nBands);
if islogical(b)
    assert(length(b) == obj.nBands, ...
        'Cube:InvalidLogicalIdx', 'Logical indexing must use a vector of length %d', obj.nBands);
else
    assert(all(b > 0) && all(b <= obj.nBands), ...
        'Cube:BandOutOfRange', 'Given band indices were out of range. Valid values are in range %d:%d', 1, obj.nBands);
end

% Convert a logical index into actual indices for the return value
idx = 1:obj.nBands;
idx = idx(b);

% Return a Cube with indexed values
obj.Data       = obj.Data(:,:,idx);
obj.Wavelength = obj.Wavelength(idx);
obj.FWHM       = obj.FWHM(idx);
obj.History    = {{'Select bands retained',@bands,idx}};
end