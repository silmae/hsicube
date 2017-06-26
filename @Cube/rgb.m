function [obj,im] = rgb(obj,b)
%RGB Display selected bands as RGB image
% [cube, im] = cube.rgb([r,g,b]) displays the band indices r, g, and b
% as RGB data using image() in a new figure. Returns the selected bands as
% a new cube along with the image handle.
if nargin < 2 && obj.nBands ~= 3, ...
    error('Cube:NotRGBData', ...
    'Supply 1x3 vector of band indices to select multispectral channels for RGB display');
elseif nargin < 2
    b = 1:3;
else
    assert(numel(b)==3, 'Cube:InvalidFalseColor', 'You must select 3 bands to display as RGB');
end

obj = obj.bands(b);
h = figure();
im = image(obj.Data);
axis image;
end