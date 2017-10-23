%% Computations on data
% The Cube class implements a host of methods for applying computations on
% the data. This example demonstrates some of them through a simple
% hyperspectral analysis workflow example.
%
% Lets load up our 'house' example file:

house = ENVI.read('house_uint16_rad.dat');
[~, img] = house.im(1);

%% Calculating reflectance
% As a first step, lets try to approximate the incoming light and calculate
% a reflectance cube. We'll pick out a part of the wall and take the mean
% radiance as our reference:

pos = [10, 74, 6, 6]; % [x, y, w, h]
hold on 
rectangle('Position', pos+[-0.5, -0.5, 1, 1], 'EdgeColor', 'r');

wr = house.crop(pos).mean();
wr.plot();

%%
% Now lets use the reference to calculate an approximate reflectance cube.
% The only thing we need to take care of is replicating the spectra to
% match the dimensions, since Cube tries to avoid mistakes by disabling
% automatic replication.

refl = house ./ wr.repmat([house.Width, house.Height, 1]);
refl.im(1);

%% 
% Doing the elementwise division loses us the nice quantity information,
% since Cube does not automatically deduce it. We can avoid this by calling
% rdivide with an additional parameter:
refl = rdivide(house, wr.repmat([house.Width, house.Height, 1]), 'Reflectance');
refl.Quantity