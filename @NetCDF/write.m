function [cube] = write(cube, filename)
%WRITE Save cube data to netcdf4 format.
% NetCDF.write(cube, filename) saves the cube to the file filename with the
% variable name given by its quantity.
% Wavelengths and FWHM values will be saved as variables 'wavelength' and
% 'fwhm' with 'band' as the related dimension, with the wavelength unit
% stored in the 'units' attribute for both variables.

nccreate(filename, cube.Quantity, ...
    'Dimensions', {'y', cube.Height, 'x', cube.Width, 'band', cube.nBands},...
    'Datatype', cube.Type,...
    'Format', 'netcdf4');
nccreate(filename, 'x', 'Dimensions', {'x'});
nccreate(filename, 'y', 'Dimensions', {'y'});
nccreate(filename, 'band', 'Dimensions', {'band'});
nccreate(filename, 'wavelength', 'Dimensions', {'band'});
nccreate(filename, 'fwhm', 'Dimensions', {'band'});

% Use zero as starting index for coordinates
ncwrite(filename, 'y', 0:cube.Height-1);
ncwrite(filename, 'x', 0:cube.Width-1);
ncwrite(filename, 'band', 0:cube.nBands-1);

ncwrite(filename, 'wavelength', cube.Wavelength);
ncwriteatt(filename, 'wavelength', 'units', cube.WavelengthUnit);
ncwrite(filename, 'fwhm', cube.FWHM);
ncwriteatt(filename, 'fwhm', 'units', cube.WavelengthUnit);

ncwrite(filename, cube.Quantity, cube.Data);

end