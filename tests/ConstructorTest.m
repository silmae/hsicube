% non-trivial data matrices 
cube   = cat(3, ones(2,3), -ones(2,3), 2*ones(2,3), -2*ones(2,3));
im     = 
rowvec = [1 2 0 3];
colvec = rowvec';

wls   = [0, 3, 1, 2];
fwhms = [2, 1, 0.5, 3];

%% Test NullConstructor
assert(isempty(Cube().Data))
assert(isempty(Cube().Bands))
assert(isempty(Cube().Wavelength))
assert(isempty(Cube().FWHM))

%% Test DataIdentity_cube
c = Cube(cube);

assert(isequal(cube, c.Data))
assert(isequal(class(cube), class(c.Data)))

%% Test DataIdentity_rowvec
c = Cube(rowvec);

assert(isequal(rowvec, c.Data))
assert(isequal(class(rowvec), class(c.Data)))

%% Test DataIdentity_rowvec
c = Cube(colvec);

assert(isequal(rowvec, c.Data))
assert(isequal(class(rowvec), class(c.Data)))

%% Test MetaIdentity
c = Cube(cube, 'wlunit', 'nm', 'wl', wls, 'fwhm', fwhms);

assert(isequal(wls, c.Wavelength))
assert(isequal(fwhm, c.FWHM))
