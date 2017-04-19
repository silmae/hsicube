% non-trivial data matrices 
cube   = cat(3, ones(2,3), -ones(2,3), 2*ones(2,3), -2*ones(2,3));
im     = magic(3);
rowvec = [1 2 0 3];
colvec = rowvec';

% test metadata
qty   = 'Quantity';
wlu   = 'Wavelength unit';
wls   = [0, 3, 1, 2];
fwhms = [2, 1, 0.5, 3];

%% Test NullConstructor
assert(isempty(Cube().Data))
assert(isempty(Cube().Bands))
assert(isempty(Cube().Wavelength))
assert(isempty(Cube().FWHM))

%% Test TypeIdentity
c = Cube(double(cube));
assert(isequal('double', class(c.Data)));
assert(isequal('double', c.Type));

c = Cube(single(cube));
assert(isequal('single', class(c.Data)));
assert(isequal('single', c.Type));

c = Cube(int8(cube));
assert(isequal('int8', class(c.Data)));
assert(isequal('int8', c.Type));

c = Cube(uint8(cube));
assert(isequal('uint8', class(c.Data)));
assert(isequal('uint8', c.Type));

c = Cube(int16(cube));
assert(isequal('int16', class(c.Data)));
assert(isequal('int16', c.Type));

c = Cube(uint16(cube));
assert(isequal('uint16', class(c.Data)));
assert(isequal('uint16', c.Type));

c = Cube(int32(cube));
assert(isequal('int32', class(c.Data)));
assert(isequal('int32', c.Type));

c = Cube(uint32(cube));
assert(isequal('uint32', class(c.Data)));
assert(isequal('uint32', c.Type));

c = Cube(int64(cube));
assert(isequal('int64', class(c.Data)));
assert(isequal('int64', c.Type));

c = Cube(uint64(cube));
assert(isequal('uint64', class(c.Data)));
assert(isequal('uint64', c.Type));

%% Test DataIdentity_cube
c = Cube(cube);
assert(isequal(cube, c.Data))

%% Test DataIdentity_im
c = Cube(im);
assert(isequal(im, c.Data))

%% Test DataIdentity_rowvec
c = Cube(rowvec);
assert(isequal(rowvec, c.Data))

%% Test DataIdentity_colvec
c = Cube(colvec);
assert(isequal(colvec, c.Data))

%% Test DefaultQuantity
c = Cube(cube);
assert(isequal('Unknown', c.Quantity));

c = Cube(cube, 'quantity', qty);
assert(isequal(qty, c.Quantity));

%% Test DefaultWavelengthUnit
c = Cube(cube);
assert(isequal('Band index', c.WavelengthUnit));

c = Cube(cube, 'wl', wls);
assert(isequal('Unknown', c.WavelengthUnit));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal('Band index', c.WavelengthUnit));

c = Cube(cube, 'wl', wls, 'fwhm', fwhms);
assert(isequal('Unknown', c.WavelengthUnit));

c = Cube(cube, 'wlunit', wlu);
assert(isequal(wlu, c.WavelengthUnit));

c = Cube(cube, 'wlunit', wlu, 'wl', wls);
assert(isequal(wlu, c.WavelengthUnit));

c = Cube(cube, 'wlunit', wlu, 'fwhm', fwhms);
assert(isequal(wlu, c.WavelengthUnit));

c = Cube(cube, 'wlunit', wlu, 'wl', wls, 'fwhm', fwhms);
assert(isequal(wlu, c.WavelengthUnit));

%% Test DefaultWavelength
c = Cube(cube);
assert(isequal(1:size(cube,3), c.Wavelength));

c = Cube(cube, 'wlunit', wlu);
assert(isequal(1:size(cube,3), c.Wavelength));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal(1:size(cube,3), c.Wavelength));

c = Cube(cube, 'wl', wls);
assert(isequal(wls, c.Wavelength));

c = Cube(cube, 'wl', wls, 'fwhm', fwhms);
assert(isequal(wls, c.Wavelength));

c = Cube(cube, 'wl', wls, 'wlunit', wlu);
assert(isequal(wls, c.Wavelength));

c = Cube(cube, 'wl', wls, 'fwhm', fwhms, 'wlunit', wlu);
assert(isequal(wls, c.Wavelength));

%% Test DefaultFWHM
c = Cube(cube);
assert(isequal(zeros(1, size(cube,3)), c.FWHM));

c = Cube(cube, 'wlunit', wlu);
assert(isequal(zeros(1, size(cube,3)), c.FWHM));

c = Cube(cube, 'wl', wls);
assert(isequal(zeros(1, size(cube,3)), c.FWHM));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wlunit', wlu);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wl', wls);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wl', wls, 'wlunit', wlu);
assert(isequal(fwhms, c.FWHM));