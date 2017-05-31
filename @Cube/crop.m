function [obj, tl, br] = crop(obj,tl,br)
%CROP Spatial crop
% CROP([tlx, tly],[brx, bry]) crops the cube spatially to a
%     rectangle defined by top left corner [tlx, tly] and
%     bottom right corner [brx, bty]. The cropped image includes both
%     corner points.

assert(isequal(size(tl), [1,2]) && isequal(size(br), [1,2]), ...
    'Cube:InvalidCoordinateSize',...
    'Corner coordinates must be supplied as 1x2 matrices [x,y]');
assert(obj.inBounds([tl; br]),'Cube:CornerOutOfBounds', ...
    'Corners must be integer coordinates inside the image plane.');
assert(tl(1) <= br(1) && tl(2) <= br(2), ...
    'Cube:InvalidCornerOrder', ...
    'Second corner must have equal or greater coordinate indices');

obj.Data = obj.Data(tl(2):br(2), tl(1):br(1), :);
obj.History = {{'Cropped spatially',@crop,tl,br}};
end