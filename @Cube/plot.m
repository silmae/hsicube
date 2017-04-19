function [obj,h] = plot(obj,h)
%PLOT Plots each spectra in the cube.
% Plots at most 50 spectra to save MATLAB from hanging, warns
% if given more.
% Uses Cube metadata to set some axis properties.
% Returns obj.byCols containing the shown spectra and the
% resulting axes handle.

% If not given an existing axis handle, creates a new one.
if nargin < 2
    h = axes();
end

% If too many pixels are present, reduces the data to the first
% 50 spatial pixels (columnwise)
if obj.Area > 50
    warning('Asked to show %d pixel spectra, reducing to the first 50.',obj.Area);
    obj = obj.take(50);
else
    obj = obj.byCols;
end
plot(h,obj.Wavelength,squeeze(obj.Data));

% If given reflectance data, scale axis accordingly.
if strcmp(obj.Quantity,'Reflectance')
    h.YLim = [0,1];
end

% Set labels based on metadata
xlabel(h,{'Wavelength',obj.WavelengthUnit});
ylabel(h,obj.Quantity);
end