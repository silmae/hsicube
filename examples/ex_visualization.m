%% Visualizing data
% For data visualization, the Cube class contains various functions that
% wrap existing MATLAB functionality in a content-aware way for each type
% of data.

house = ENVI.read('house_uint16_rad.dat', 'Radiance');

%% HSI histograms
% The hist() method calculates histograms for each band in the data using
% MATLAB histcounts, and displays them as a image with a colormap.

house.hist('count');

%%
% By default, the bins are set automatically based on the whole dataset
% (with a single binning for all the bands). To set a custom binning, we
% can pass the bin edges as a parameter.

bin_edges = 0:65536;
house.hist('count', bin_edges);
