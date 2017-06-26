function [obj,ax] = plot(obj, h)
%PLOT Plots spectra in the cube.
% [c, ax] = cube.PLOT() plots each pixel spectra in cube.
% If more than 50 pixels are present, limits the plot to the first 50 
% (columnwise) to prevent MATLAB from choking. Returns the cube containing
% the plotted spectra (50 first pixels if limit reached, otherwise
% unchanged) and the handle to the plot axes.
% 
% [c, h] = cube.PLOT(h) sets the given figure h as active and uses it for
% the plot.

% If too many pixels are present, reduces the data to the first
% 50 spatial pixels (columnwise)
if obj.Area > 50
    warning('Asked to show %d pixel spectra, reducing to the first 50.',obj.Area);
    obj = obj.take(50);
else
    obj = obj.byCols;
end

% If not given an existing figure handle, creates a new one.
if nargin < 2
    h = figure();
else
    h = figure(h);
end

% Set hold on in case we are plotting in an existing figure, then plot
% the data
hold on;
plot(obj.Wavelength,squeeze(obj.Data));
hold off;

% Set labels based on metadata
ax = gca;
xlabel(ax, {'Wavelength',obj.WavelengthUnit});
ylabel(ax, obj.Quantity);

end