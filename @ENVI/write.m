function [cube] = write(cube, filename, overwrite)
%ENVI.WRITE Save cube data to an ENVI format file
% ENVI.WRITE(cube, filename) saves the Cube data and applicable
% metadata to the given ENVI data and header files. 'filename'
% should be the desired filename without the file extension.
% Currently does not save the object history. If either the header file or
% data file exists, aborts with an error.
% 
% ENVI.WRITE(..., 'overwrite') can be supplied to overwrite existing files.

if nargin < 3
    forceoverwrite = false;
else
    assert(strcmp(overwrite, 'overwrite'), ...
        'ENVI:InvalidOverwriteParam', ...
        'Invalid overwrite parameter. Call ENVI.write(... ''overwrite'') to force writing over existing files.');
    forceoverwrite = true;
end

hdrfile = [filename, '.hdr'];
datafile = [filename, '.dat'];

if ~forceoverwrite
    assert(exist(hdrfile, 'file')==0, ...
        'ENVI:ExistingHeaderFile', ...
        'Header file %s already exists, aborting', hdrfile);
    assert(exist(datafile, 'file')==0,...
        'ENVI:ExistingDataFile',...
        'Data file %s already exists, aborting', datafile);
end
    
% Generate ENVI header info
info = enviinfo(cube.Data);
info.description = ['{', strjoin(cube.Files, ' '), '}'];
info.wavelength_units = cube.WavelengthUnit;
info.wavelength = ['{', num2str(cube.Wavelength, '%f, '), '}'];
info.fwhm = ['{', num2str(cube.FWHM, '%f, '), '}'];

enviwrite(cube.Data, info, datafile, hdrfile);
end