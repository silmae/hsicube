function [cube] = read(filename, variable)
%READ Read cube data from a netcdf file.
% cube = NetCDF.read(filename, variable) read the data of a given variable
% to a Cube object along with relevant metadata.

% Start by reading the data
g = ncread(filename, variable);

% Construct the constructor parameters as a cell array, appending
% metadata arguments
cargs = {g, 'file', filename, 'quantity', variable};

% Read wavelength, fwhm and unit info. We assume that the wavelength unit
% for fwhm is the same
try
    cargs = [cargs, 'wl', ncread(filename, 'wavelength')];
catch
    warning('Wavelengths could not be found, using default value.');
end
try
    cargs = [cargs, 'fwhm', ncread(filename, 'fwhm')];
catch
    warning('FWHMs could not be found, using default value.');
end
try
    cargs = [cargs, 'wlu', ncreadatt(filename, 'wavelength', 'units')];
catch
    warning('Wavelength unit could not be found, using default value.');
end

% Construct the cube object
cube = Cube(cargs{:});

end