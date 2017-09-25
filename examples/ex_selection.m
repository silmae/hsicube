%% Data selection

%%
% The Cube class does not directly implement the normal MATLAB slicing
% syntax. Instead, multiple methods are provided for selecting parts of a
% data cube. We first load up 

example = ENVI.read('example.dat');
orig_range = example.Wavelength([1,end]);
disp(example);

%% Selecting bands
% Selecting bands can be done using the methods bands() in two ways:
% 
% * By passing explicit indices as vectors:

example.bands(1:5).plot();
xlim(orig_range)

%%

example.bands([1,16,32]).plot();
xlim(orig_range)

%%
% * By passing a logical matrix:

example.bands(example.Bands > 16).plot();
xlim(orig_range)
%% 

example.bands(example.Wavelength < 550).plot();
xlim(orig_range)

%% 
% Note here the use of the properties Bands and Wavelengths. The first
% always contains the band indices of the Cube, while the latter contains
% the wavelength information for each bands.

%% Selection by coordinates
% Selecting spectra by their pixel coordinates is possible using px(). This
% returns the selected pixel spectra as a Cube containing a list 
% (N x bands matrix):

corners = [1,  1; % Top left
           64, 1; % Top right
           1, 64; % Bottom left
           64,64; % Bottom right
           ];
example.px(corners).plot();