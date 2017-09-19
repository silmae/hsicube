%% Using the ENVI class

%% Reading ENVI data to a Cube
% ENVI data consists of a header file (.hdr) and a data file (.dat) with
% the same base name. To read a radiance cube from a file, we use the
% ENVI.read() method, giving it the filename of the .dat-file and a
% quantity (without it, ENVI.read() will set the default 'Unknown').

envifile = 'example.dat';
cube = ENVI.read(envifile, 'Radiance')

% We see from the output that the metadata in the matching ENVI header file
% (example.hdr) was automatically read to the Cube object properties 
% Wavelength and FWHM, and the quantity was set to 'Radiance'.