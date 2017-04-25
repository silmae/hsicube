function [obj, idx] = bands(obj,b)
%BANDS Band selection
% bands(b) returns a cube with only the given bands.
% Valid values for b are
%   - A vector of integer values in the range 1:nBands. If an
%     index is supplied multiple times, the result will contain
%     copies of the given band.
%   - A logical vector with length equal to nBands.

% Input validation
assert(isvector(b), ...
    'Cube:InvalidIdxShape', 'Bands must be specified as a row or column vector');
assert(all(isint(b)),... % Note that this passes for logical indices
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