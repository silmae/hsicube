function [cube] = write(cube, filename)
%ENVI.WRITE Save cube data to an ENVI format file
% envi.write(cube, filename) saves the Cube data and applicable
% metadata to the given ENVI data and header files. 'filename'
% should be the desired filename without the file extension.
% Currently does not save the object history.
% Note that this will overwrite existing files without warning.

% Generate ENVI header info
info = enviinfo(cube.Data);
info.description = ['{', strjoin(cube.Files, ' '), '}'];
info.wavelength_units = cube.WavelengthUnit;
info.wavelength = ['{', num2str(cube.Wavelength, '%f, '), '}'];
info.fwhm = ['{', num2str(cube.FWHM, '%f, '), '}'];

hdrfile = [filename, '.hdr'];
datafile = [filename, '.dat'];
enviwrite(cube.Data, info, datafile, hdrfile);
end