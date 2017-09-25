%% Data selection

%%
% The Cube class does not directly implement the normal MATLAB slicing
% syntax. Instead, multiple methods are provided for selecting parts of a
% data cube. We first load up 

example = ENVI.read('example.dat');
disp(example);

%% Selecting bands
% Selecting bands can be done using the methods bands() in two ways:
% 
% * By passing explicit indices as vectors:

example.bands(1:5)
%%

example.bands([5,6,8])

%%
% * By passing a logical matrix:

example.bands(example.Bands < 41)
%% 

example.bands(example.Wavelength < 550)

%% 
% Note here the use of the properties Bands and Wavelengths. The first
% always contains the band indices of the Cube, while the latter contains
% the wavelength information for each bands.