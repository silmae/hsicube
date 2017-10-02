function [obj,im] = rgb(obj,b)
%RGB Display an RGB representation of the data cube
% Usage:
% [cube, im] = cube.rgb() displays the cube data using image. If the cube
%   has WavelengthUnit set to 'nm', it uses the CIE color matching 
%   functions to calculate the sRGB values.
%   For other values of WavelengthUnit, it will error unless the cube has
%   exactly 3 bands, in which case it will attempt to display them.
%   In either case, rgb normalizes the data by clipping the values to the
%   interval [0, 1] and applies gamma correction with a 1/2 factor.
% [cube, im] = cube.rgb([r,g,b]) displays the given band indices r, g, and b
%   as R, G and B layers, applying normalization and gamma correction.
% 
if nargin < 2 && obj.nBands ~= 3
    if strcmp(obj.WavelengthUnit, 'nm')
        % Use the CIE CMF to calculate the XYZ coords, then sRGB colors using
        % MATLAB xyz2rgb
        xyz = Utils.CIE_XYZ(obj.Wavelength);
        obj = obj.mapSpectra(...
                @(x) xyz2rgb(x * xyz, ...
                  'ColorSpace', 'sRGB'), ...
                    'quantity', 'sRGB', ...
                    'wlu', 'Color', ...
                    'wl', [1,2,3],... % Placeholder, wl must be numerical
                    'fwhm', zeros(1,3));
    else
        error('Cube:InvalidRGBData', ...
         'Cannot calculate RGB values. Supply band indices to select channels for RGB display');
    end
else
    if nargin == 2
        assert(numel(b)==3, 'Cube:InvalidRGBIndices', 'You must select 3 bands to display as RGB');
    else
        b = 1:3;
    end
    obj = obj.bands(b);
end

% Normalize the image and apply gamma correction
obj = obj.mapBands(@(x) min(max(x,0),1).^0.5, 'Normalized sRGB');
h = figure();
im = image(obj.Data);
axis image;

end