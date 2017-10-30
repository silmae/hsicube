%% Visualizing data
% For data visualization, the Cube class contains various functions that
% wrap existing MATLAB functionality in a content-aware way for each type
% of data.

house = ENVI.read('house_uint16_rad.dat', 'Radiance');

%% Multiband image histograms
% The hist() method calculates histograms for each band in the data using
% MATLAB histcounts, and displays them as a image with a colormap.

house.hist('count');

%%
% By default, the bins are set automatically based on the whole dataset
% (with a single binning for all the bands). To set a custom binning, we
% can pass the bin edges as a parameter.

bin_edges = 0:65536;
house.hist('count', bin_edges);

%% Displaying single bands
% Single bands can be displayed by calling im(band_idx). The method will
% return the plotted data, and a handle to the image object, which lets us
% keep plotting in the same figure:

[~, im_h] = house.im(64);

% Lets select some points of interest:
xy  = [15,75;...
       15,85;...
       25,45];
hold on;
scatter(im_h.Parent, xy(:,1), xy(:,2), 'r', 'filled');

%% Plotting spectra
% Plotting can be done using the plot() method. We shall plot the spectra
% from the previously selected points with a suitable legend. Note that
% the coordinates used are the same as used for the scatter plot in the
% image coordinates (x, then y).
% The plot() method returns us the plotted data as a cube and an axis
% handle.

xy_legend = {'Wall', 'Window', 'Tree'};
[S, ax] = house.px(xy).plot();
legend(ax, xy_legend);

%% RGB image calculation
% The rgb() method can be used to calculate and display an sRGB
% representation of calibrated radiance data in the visible range (or to
% produce false-color images by giving it band indices).
% Since the house datacube is originally valid radiance data, we
% can try this by just reconverting it back to the original units, and then
% giving the rgb() method a try:
house.mapBands(@(x) double(x) * (0.001190876864732/65535), 'Radiance').rgb();