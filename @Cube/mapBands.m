function obj = mapBands(obj, f, history, qty)
%MAPBANDS Apply a function on each band of the data
% mapBands(f,history,qty) applies f on each band (image) and
% returns a Cube with the resulting data. User must supply a
% history string to be included in the result history, and the
% quantity specification for the new data.
% Changes in wavelength and fwhm values are not supported,
% though the spatial dimensions of the data may change.

assert(isa(f,'function_handle'),...
    'Expected a valid function handle');
assert(CubeArgs.isValidQuantity(qty),...
    'Quantity specification must be a non-empty char array');

for b = obj.Bands
    tmp(:,:,b) = f(obj.Data(:,:,b));
end

obj.Data     = tmp;
obj.Quantity = qty;
obj.History  = {{'Applied function on each band',...
    f, history, qty}};
end
