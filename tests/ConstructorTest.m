% non-trivial data matrices 
data  = cat(3, ones(2,3), -ones(2,3), 2*ones(2,3), -2*ones(2,3));
wls   = [0, 3, 1, 2];
fwhms = [2, 1, 0.5, 3];

%% Test NullConstructor
assert(isempty(Cube().Data))
assert(isempty(Cube().Bands))
assert(isempty(Cube().Wavelength))
assert(isempty(Cube().FWHM))

%% Test DataIdentity
c = Cube(data, 'Test values', 'wl', wls, 'fwhm', fwhms);

assert(isequal(data, c.Data))
assert(isequal(class(data), class(c.Data)))

assert(isequal(wls, c.Wavelength))
assert(isequal(fwhms, c.FWHM))