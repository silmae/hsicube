function obj = take(obj,n)
%TAKE Take the first n pixel spectra (in column order)
% Usage: TAKE(N), where n = 1,...,Area returns a cube
% containing the first n pixels in a single column.
% If n > Area, returns all the pixels.
assert(Utils.isnatural(n), ...
    'Cube:InvalidAmount', 'N must be a natural number');

if n > obj.Area
    n = obj.Area;
end

obj.History = {{'Taking n first pixels', @take, n}};
obj = obj.byCols.px([ones(n,1),(1:n)']);
end