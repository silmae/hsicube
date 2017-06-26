function [obj,h] = slice(obj, method)
%SLICE Examine the cube data using im_cube_slicer
% h = cube.SLICE(method) opens the cube data using im_cube_slicer and the
% given scaling method. If no parameters are given, defaults to 'scaled'.
% Subsampling is fixed to 1. See im_cube_slicer for more info.
% Requires im_cube_slicer.m (Timo Eckhard, Jia Song) in path.

if nargin < 2
    method = 'scaled';
end

h = im_cube_slicer(obj.Data, obj.Wavelength, 1, method);

end