function obj = unCols(obj, W, H)
%UNCOLS Reshape columnwise listed spectra into the given shape
% UNCOLS(width, height) attempts to restructure the
% (W * H) x 1 x Bands Cube data into an Width x Height x Bands cube.
% Will error if the given dimensions do not match the Cube area or if the
% Cube data has width greater than 1.

assert(obj.Height == obj.Area, ...
    'Cube:NotAList', 'Cube data must be columnwise ordered list of spectra.');
assert(W * H == obj.Area, ...
    'Cube:InvalidArea', ...
    'Given width and height (%d x %d = %d) do not match the number of spectra (%d)', ...
    W, H, W*H, obj.Area);

obj = obj.unmask(true(H, W));
% History will be added by unmask
end
