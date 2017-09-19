%% Using map to apply functions to data 

sum_radiance = @(x) sum(x,3);

% The new data won't be radiance, so we have to tell the object to change
% some things. As an example, lets do something almost smart with the
% wavelengths:
new_quantity   = 'Radiance (summed)';
new_wls        = (cube.Wavelength(1) + cube.Wavelength(end)) / 2;
new_fwhms      = cube.Wavelength(end) - cube.Wavelength(1);
new_wlunit     = cube.Wavelength_Unit;

%%
% Now we can map the function on the data, while adding a string to the
% Cube history to mark our intention:
history_entry  = 'Calculated total radiance for each pixel';

C_summed = cube.map(sum_radiance, 'history', history_entry,...
    'quantity', new_quantity, 'wlu', new_wlunit, 'wl', new_wls, 'fwhm', new_fwhms)