function [obj,im] = rgb(obj,b)
%RGB Display an RGB image using the selected bands
% Returns the cube reduced to the given bands and the
% resulting image object.
obj = obj.bands(b);
im = image(obj.Data);
end