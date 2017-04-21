% test cube with 4 bands and non-square dimensions (size [2,3,4])
cube   = cat(3, ones(2,3), 2*ones(2,3), 3*ones(2,3), 4*ones(2,3));

% test metadata matching the cube
qty   = 'Quantity';
wlu   = 'Wavelength unit';
wls   = [0, 3, 1, 2];
fwhms = [2, 1, 0.5, 3];

% expected default values for missing parameters for the cube
default_qty  = 'Unknown';
default_wlu  = 'Band index';
default_wlu_with_given_wl = 'Unknown';
default_wl   = 1:size(cube,3);
default_fwhm = zeros(1, size(cube,3));

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
im     = [1  2  3  4;
          5  6  7  8;
          9 10 11 12];
c = Cube(im);
assert(isequal(im, c.Data))

%% Test DataIdentity_rowvec
rowvec = [1 2 3 4];
c = Cube(rowvec);
assert(isequal(rowvec, c.Data))

%% Test DataIdentity_colvec
colvec = [1 2 3 4]';
c = Cube(colvec);
assert(isequal(colvec, c.Data))

%% Test DefaultQuantity
c = Cube(cube);
assert(isequal(default_qty, c.Quantity));

c = Cube(cube, 'quantity', qty);
assert(isequal(qty, c.Quantity));

%% Test DefaultWavelengthUnit
c = Cube(cube);
assert(isequal(default_wlu, c.WavelengthUnit));

c = Cube(cube, 'wl', wls);
assert(isequal(default_wlu_with_given_wl, c.WavelengthUnit));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal(default_wlu, c.WavelengthUnit));

c = Cube(cube, 'wl', wls, 'fwhm', fwhms);
assert(isequal(default_wlu_with_given_wl, c.WavelengthUnit));

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
assert(isequal(default_wl, c.Wavelength));

c = Cube(cube, 'wlunit', wlu);
assert(isequal(default_wl, c.Wavelength));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal(default_wl, c.Wavelength));

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
assert(isequal(default_fwhm, c.FWHM));

c = Cube(cube, 'wlunit', wlu);
assert(isequal(default_fwhm, c.FWHM));

c = Cube(cube, 'wl', wls);
assert(isequal(default_fwhm, c.FWHM));

c = Cube(cube, 'fwhm', fwhms);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wlunit', wlu);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wl', wls);
assert(isequal(fwhms, c.FWHM));

c = Cube(cube, 'fwhm', fwhms, 'wl', wls, 'wlunit', wlu);
assert(isequal(fwhms, c.FWHM));

%% Test CopyConstructor
c1 = Cube(cube, 'quantity', qty, 'wlunit', wlu, 'wl', wls, 'fwhm', fwhms);
c2 = Cube(c1);

assert(isequal(c1.Data, c2.Data));
assert(isequal(class(c1.Data), class(c2.Data)));
assert(isequal(c1.Type, c2.Type));
assert(isequal(c1.Quantity, c2.Quantity));
assert(isequal(c1.WavelengthUnit, c2.WavelengthUnit));
assert(isequal(c1.Wavelength, c2.Wavelength));
assert(isequal(c1.FWHM, c2.FWHM));

%% Test UpdateConstructor_Quantity
c1 = Cube(cube, 'quantity', 'OldQuantity');
c2 = Cube(c1,   'quantity', 'NewQuantity');

assert(isequal(c1.Quantity, 'OldQuantity'));
assert(isequal(c2.Quantity, 'NewQuantity'));

%% Test UpdateConstructor_WavelengthUnit
c1 = Cube(cube, 'wlunit', 'OldWavelengthUnit');
c2 = Cube(c1,   'wlunit', 'NewWavelengthUnit');

assert(isequal(c1.WavelengthUnit, 'OldWavelengthUnit'));
assert(isequal(c2.WavelengthUnit, 'NewWavelengthUnit'));

%% Test UpdateConstructor_Wavelength
c1 = Cube(cube, 'wl', 1:4);
c2 = Cube(c1,   'wl', 2:5);
assert(isequal(c1.Wavelength, 1:4));
assert(isequal(c2.Wavelength, 2:5));
assert(isequal(c1.WavelengthUnit, default_wlu_with_given_wl));
assert(isequal(c2.WavelengthUnit, default_wlu_with_given_wl));

c1 = Cube(cube, 'wl', 1:4, 'wlunit', wlu);
c2 = Cube(c1,   'wl', 2:5);
assert(isequal(c1.Wavelength, 1:4));
assert(isequal(c2.Wavelength, 2:5));
assert(isequal(c1.WavelengthUnit, wlu));
assert(isequal(c2.WavelengthUnit, default_wlu_with_given_wl));

c1 = Cube(cube, 'wl', 1:4, 'wlunit', wlu);
c2 = Cube(c1,   'wl', 2:5, 'wlunit', wlu);
assert(isequal(c1.Wavelength, 1:4));
assert(isequal(c2.Wavelength, 2:5));
assert(isequal(c1.WavelengthUnit, wlu));
assert(isequal(c2.WavelengthUnit, wlu));

%% Test UpdateConstructor_FWHM
c1 = Cube(cube, 'fwhm', [1 1 1 1]);
c2 = Cube(c1,   'fwhm', [2 2 2 2]);
assert(isequal(c1.FWHM, [1 1 1 1]));
assert(isequal(c2.FWHM, [2 2 2 2]));
assert(isequal(c1.WavelengthUnit, default_wlu));
assert(isequal(c2.WavelengthUnit, default_wlu));

c1 = Cube(cube, 'fwhm', [1 1 1 1], 'wlunit', wlu);
c2 = Cube(c1,   'fwhm', [2 2 2 2]);
assert(isequal(c1.FWHM, [1 1 1 1]));
assert(isequal(c2.FWHM, [2 2 2 2]));
assert(isequal(c1.WavelengthUnit, wlu));
assert(isequal(c2.WavelengthUnit, wlu));