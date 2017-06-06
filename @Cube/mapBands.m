function obj = mapBands(obj, f, qty)
%MAPBANDS Apply a function on each band of the data
% mapBands(f, qty) applies f on each band (image) and
% returns a Cube with the resulting data. The result quantity will be set
% to qty. If the quantity is not supplied, it will be set to 'Unknown'.

assert(isa(f,'function_handle'),...
    'Expected a valid function handle');

for b = obj.Bands
    tmp(:,:,b) = f(obj.Data(:,:,b));
end

if nargin < 3
    qty = 'Unknown';
end

obj.Data     = tmp;
obj.Quantity = qty;
obj.History  = {{'Applied function on each band',f}};
end
