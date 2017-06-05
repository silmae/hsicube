function obj = map(obj,f,history,qty,wlunit,wls,fwhm)
%MAP Applies the given function on the cube data
% map(f,history,qty,wlunit,wls,fwhm) applies the function f on
% the data and returns a cube with the resulting data. The user
% must supply an explanatory history string to be included in
% the result history.
% The user must supply a new quantity, wavelengths, fwhms and
% wavelength unit that correspond to the new data. Note that
% a validity check on the supplied values is done AFTER
% computing f, and if errors occur, the resulting data will be
% lost.

% Do some validity checks beforehand (not enough to guarantee
% success, since the result of f and the supplied values might
% conflict)
assert(isa(f,'function_handle'),...
    'Expected a valid function handle');
assert(CubeArgs.isValidQuantity(qty),...
    'Quantity specification must be a non-empty char array');
assert(ischar(wlunit),...
    'Wavelength unit specification must be a char array');
assert(ischar(history),...
    'Explanatory history entry must be a string');

% Hope for the best and let setters fail on any inconsistancies.
obj.Data       = f(obj.Data);
obj.Quantity   = qty;
obj.Wavelength = wls;
obj.FWHM       = fwhm;
obj.WavelengthUnit = wlunit;
obj.History    = {{'Applied a function on the data',...
    @map, f, history, qty, wls, fwhm, wlunit}};
end