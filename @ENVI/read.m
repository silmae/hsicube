function [cube] = read(filename, qty)
%ENVI.READ Reads an ENVI format file as a Cube object
% [cube] = read(filename) returns a Cube object containing the data in
% filename. The given filename should be the full path to an ENVI file
% (with a .dat extension)

hdrfile = ENVI.findhdr(filename);

fprintf('Reading ENVI data from %s\n', hdrfile);
[g, info] = enviread(filename, hdrfile);
fprintf('ENVI data read.\n');

% Construct the constructor parameters as a cell array, appending
% metadata arguments if they are known
cargs = {g, 'file', hdrfile};

if nargin == 2
    cargs = [cargs, 'quantity', qty];
end

if isfield(info,'wavelength_units')
    cargs = [cargs, 'wlu', info.wavelength_units];
end

% Check here explicitly for case-sensitivity
% TODO: implement this generally for all the fields
if isfield(info, 'wavelength')
    cargs = [cargs, 'wl', str2num(info.wavelength(2:end-1))];
elseif isfield(info,'Wavelength')
    cargs = [cargs, 'wl', str2num(info.Wavelength(2:end-1))];
end

if isfield(info,'fwhm')
    cargs = [cargs, 'fwhm', str2num(info.fwhm(2:end-1))];
end

% Create a Cube using the collected arguments
cube = Cube(cargs{:});

end