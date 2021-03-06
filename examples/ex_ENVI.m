%% Using the ENVI class

%% Reading ENVI data to a Cube
% ENVI data consists of a header file (.hdr) and a data file (.dat) with
% the same base name. To read a radiance cube from a file, we use the
% ENVI.read() method, giving it the filename of the .dat-file and a
% quantity (without it, ENVI.read() will set the default 'Unknown').

envifile = 'example.dat';
example = ENVI.read(envifile, 'Radiance');
disp(example);

%%
% We see from the output that the metadata in the matching ENVI header file
% (example.hdr) was automatically read to the Cube object properties 
% Wavelength and FWHM, and the quantity was set to 'Radiance'.

%% Writing Cube data to ENVI
% Writing Cube data to ENVI files is done simply using the ENVI.write()
% method:

try
    ENVI.write(example, 'example');
catch e
    disp(e.message)
end

%%
% This attempts to save the data to 'random_envi.dat' and write the 
% metadata to 'random_envi.hdr'. The default is to not overwrite any 
% existing files (neither .dat nor .hdr), which results in an exception.
% This can be overridden by calling ENVI.write(cube, filename, 'overwrite').