function [obj,im] = im(obj, b)
%IM Display the given band as an image
% [band, im] = cube.IM(b) displays the given band b using imagesc with 
% added colorbar. Returns the selected band as a cube and a handle
% to the image.
% 
% If colorbrewer is found, the *GnBu colormap will be used instead of the
% default parula.

if nargin < 2 && obj.nBands == 1
    b = 1;
else
    assert(isscalar(b), ...
        'Cube:InvalidSingleBand', ...
        'You must supply a single band index for visualization');
end
obj = obj.bands(b);
h = figure();
im = imagesc(squeeze(obj.Data));
axis image;
title(sprintf('Band %d (%f%s)', b, obj.Wavelength(1), obj.WavelengthUnit));

if exist('brewermap.m', 'file') == 2
    colormap(brewermap(100, '*GnBu'));
else
    colormap(parula);
end

cb = colorbar(gca);
cb.Label.String = obj.Quantity;
end
