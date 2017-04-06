% test data matrices
c = cat(3, ones(2,3), -ones(2,3), 2*ones(2,3), -2*ones(2,3));

%% Test NullConstructor
assert(isempty(Cube().Data))
assert(isempty(Cube().Bands))
assert(isempty(Cube().Wavelength))
assert(isempty(Cube().FWHM))
