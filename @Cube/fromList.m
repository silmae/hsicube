function obj = fromList(obj, W, H)
%FROMLIST Reshape a list of spectra into the given shape
% c2 = c1.FROMLIST(width, height) attempts to restructure the
% (W * H) x 1 x Bands Cube c1 into an Width x Height x Bands cube c2.
% The order is the reverse of 
% If the given dimensions do not match the Cube area or if the
% Cube data has width greater than 1, an error will be thrown.
% 
% See also: TOLIST, MASK, UNMASK

assert(obj.Height == obj.Area, ...
    'Cube:NotAList', 'Cube data must be columnwise ordered list of spectra.');
assert(W * H == obj.Area, ...
    'Cube:InvalidArea', ...
    'Given width and height (%d x %d = %d) do not match the number of spectra (%d)', ...
    W, H, W*H, obj.Area);

obj = obj.unmask(true(H, W));
% History will be added by unmask
end
