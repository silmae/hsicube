function [obj,im] = im(obj, b)
%IM Display the given band as an image
% [band, im] = cube.IM(b) displays the given band b using imagesc. Returns
% the selected band as a cube along with a handle to the image.

assert(isscalar(b), ...
    'Cube:InvalidSingleBand', ...
    'You must supply a single band index for visualization');
obj = obj.bands(b);
h = figure();
im = imagesc(squeeze(obj.Data));
axis image;
colorbar(gca);
end
