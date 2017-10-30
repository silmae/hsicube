%% Data selection
% The Cube class does not directly implement the normal MATLAB slicing
% syntax. Instead, multiple methods are provided for selecting parts of a
% data cube. We first load up some example data, and retrieve the
% wavelength range to synchronize the visualizations.

house = ENVI.read('house_uint16_rad.dat');
orig_range = house.Wavelength([1,end]);
disp(house);

%% Selecting bands
% Selecting bands can be done using the methods bands() in two ways. We 
% 
% * By passing explicit indices as vectors:

house.bands(32:64).plot();
xlim(orig_range)

%%

house.bands([1,64,128]).plot();
xlim(orig_range)

%%
% * By passing a logical matrix:

house.bands(house.Bands > 64).plot();
xlim(orig_range)
%% 
% This can easily be used with the synchronized wavelength metadata to
% slice by wavelengths:
house.bands(house.Wavelength < 550).plot();
xlim(orig_range)


%% Selection by coordinates
% Selecting spectra by their pixel coordinates is possible using px(). This
% returns the selected pixel spectra as a Cube containing a list 
% (N x bands matrix):

corners = [1,  1; % Top left
           64, 1; % Top right
           1, 64; % Bottom left
           64,64; % Bottom right
           ];
house.px(corners).plot();