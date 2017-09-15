%% Operating on ENVI files
%
% You can run 
% 
% publish('ENVIExample.m')
% 
% to generate an html presentation of this example.

%% Creating a Cube from ENVI data
% ENVI data consists of a header file (.hdr) and a data file (.dat) with
% the same base name. To read a radiance cube from a file, we use the
% ENVI.read() method, giving it the filename and a quantity (otherwise it
% will default to 'Unknown'):

envifile = 'jyvasjarvi400650_RAD.dat';
C = ENVI.read(envifile, 'Radiance')

%% 
% We can check that also the ENVI metadata was read by accessing the
% properties of the Cube:

disp(C.Wavelength)
disp(C.FWHM)

%% Applying functions to Cube data
% If we assume the data had some "pure white" pixels, we could use one to 
% construct some sort of a reference. Lets see which pixels have the
% highest radiance overall. To do this, first we define the operation as a
% function on the data (Height x Width x Band matrix):

sum_radiance = @(x) sum(x,3);

%%
% The new data won't be radiance, so we have to tell the object to change
% some things. As an example, lets do something almost smart with the
% wavelengths:
new_quantity   = 'Radiance (summed)';
new_wls        = (C.Wavelength(1) + C.Wavelength(end)) / 2;
new_fwhms      = C.Wavelength(end) - C.Wavelength(1);
new_wlunit     = C.Wavelength_Unit;

%%
% Now we can map the function on the data, while adding a string to the
% Cube history to mark our intention:
history_entry  = 'Calculated total radiance for each pixel';

C_summed = C.map(sum_radiance, 'history', history_entry,...
    'quantity', new_quantity, 'wlu', new_wlunit, 'wl', new_wls, 'fwhm', new_fwhms)

%% Displaying Cube data
% We can see the resulting image by using the im method, which shows us an
% image of the given band. In this case, the data has only one, so lets see
% that:

C_summed.im(1);

%% Picking pixels
% The image is upside down, but we'll fix it later. Let's find the
% brightest pixel and see what the spectrum looks like in the original
% data:

[~, max_idx] = max(C_summed.Data(:));
[max_y,max_x] = ind2sub(C_summed.Size, max_idx);

% Note that px() takes its arguments in the order x, y
figure();
ah = axes();
[max_spectra, ~] = C.px(max_x,max_y).plot(ah);

%% Replicating spectra
% Now max_spectra contains the maximum radiances found. Let's construct a
% mock white reference from it. We make a Cube from the data and use the 
% corresponding wavelengths etc. from the original data.

history = 'Generated a mockup white reference'; % Explanatory history
wr = Cube(repmat(max_spectra.Data,C.Height,C.Width),... % Data as 1st param
    'Radiance',... % Quantity, white reference data must be Radiance
    'wlu',C.Wavelength_Unit,... % Existing values passed as name-value pairs
    'wl',C.Wavelength,...
    'fwhm',C.FWHM)

%%
% Now we can use the new white reference to calculate reflectances from our
% original data. Lets also flip it right side up, while we're at it:

[C, imh] = C.toReflectance(wr).flipY().im(1);

