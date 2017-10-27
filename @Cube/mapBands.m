function obj = mapBands(obj, f, qty, res_band_multiplier)
%MAPBANDS Apply a function on each band of the data
% mapBands(f, qty) applies f on each band (image) and
% returns a Cube with the resulting data. The result quantity will be set
% to qty. If the quantity is not supplied, it will be set to 'Unknown'.
%
% By default, mapBands assumes that the number of bands is preserved, while
% the spatial size may change. This will result in an error if the result
% of the given function is not assignable to a single band. You can call 
% mapBands(f, qty, res_band_multiplier) to specify the number of bands
% returned by each function application. In this case, the total number of
% bands in the result will be nBands_original * res_band_multiplier.

assert(isa(f,'function_handle'),...
    'Expected a valid function handle');

if nargin < 4
    res_band_multiplier = 1;
end

if nargin < 3
    qty = 'Unknown';
end

obj.Quantity = qty;

for b = obj.Bands
    tmp(:,:,b:b+res_band_multiplier-1) = f(obj.Data(:,:,b));
end
obj.Data     = tmp;
obj.History  = {{'Applied function on each band',f}};
end
