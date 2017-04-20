% simple [2,3,4] cube for testing
data = cat(3, ones(2,3), 2*ones(2,3), 3*ones(2,3), 4*ones(2,3));
c = Cube(data);

%% Test AllBandsIdentity
d = c.bands(1:c.nBands);

assert(isequal(d.Data, data)); 
assert(isequal(d.Wavelength, c.Wavelength));
assert(isequal(d.FWHM, c.FWHM));

%% Test BandOrder
for k = 1:size(data,3);
	d = c.bands(k);

	assert(isequal(d.Data, data(:,:,k))); 
	assert(isequal(d.Wavelength, c.Wavelength(k)));
	assert(isequal(d.FWHM, c.FWHM(k)));
end
