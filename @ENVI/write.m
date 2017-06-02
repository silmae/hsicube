function [cube] = write(cube, filename)
%ENVI.WRITE Save cube data to an ENVI format file
% envi.write(cube, filename) saves the Cube data and applicable
% metadata to the given ENVI data and header files. 'filename'
% should be the desired filename without the file extension.
% Currently does not save the object history.

% Generate ENVI header info
info = enviinfo(cube.Data);
info.description = ['{', strjoin(cube.Files, ' '), '}'];
info.wavelength_units = cube.WavelengthUnit;
info.wavelength = ['{', num2str(cube.Wavelength, '%f, '), '}'];
info.fwhm = ['{', num2str(cube.FWHM, '%f, '), '}'];

hdrfile = [filename, '.hdr'];
datafile = [filename, '.dat'];
assert(exist(hdrfile, 'file')==0, 'Header file %s already exists, aborting', hdrfile);
assert(exist(datafile, 'file')==0, 'Data file %s already exists, aborting', datafile);
enviwrite(cube.Data, info, datafile, hdrfile);
end