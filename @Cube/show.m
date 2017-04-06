function [obj,h] = show(obj)
%SHOW Examine the cube data
% Chooses the method based on data dimension and returns
% the resulting handle.
% Full cube (H x W x B) uses im_cube_slicer.
% (Must have im_cube_slicer (Timo Eckhard, Jia Song) in path.)
%
% Three-band images are shown using rgb.
%
% Single-band images (H x W x 1) are displayed using im.
%
% Spectra (Area x 1 x B or 1 x Area x B) are plotted.

if obj.Width == 1 || obj.Height == 1
    [obj,h] = obj.plot();
elseif obj.nBands == 3
    [obj,h] = obj.rgb(obj.Bands);
elseif obj.nBands == 1
    [obj,h] = obj.im();
else
    h = im_cube_slicer(obj.Data, 1:obj.Size(3),1,'fixed');
end
end