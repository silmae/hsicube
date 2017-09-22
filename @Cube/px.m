function [obj, cx] = px(obj,cx)
%PX Select pixels from the cube
% Usage: PX([x,y]) with x, y column vectors of pixel coordinates.
% Returns the cube containing the points [x,y] in the original
% cube. 
% Note that this is the opposite order to MATLAB default indexing.
assert(isequal(size(cx), [size(cx,1), 2]), ...
    'Cube:InvalidCoordinateSize',...
    'Coordinates must be supplied as an N x 2 matrix');
assert(obj.inBounds(cx), ...
    'Cube:CoordinateOutOfBounds', ...
    'Coordinates must be pairs of integers between [1, 1] and [%d,%d]',obj.Width,obj.Height);

% Reshape using toList so that the rows match spatial linear
% indexing. History is appended here first so that arguments of
% px are sound for the cube before toList.
% Note the order of indexing.
obj.History = {{'Selected pixels retained',@px,cx}};

idx = sub2ind(obj.Size(1:2), cx(:,2), cx(:,1));
obj.Data = obj.toList.Data(idx, 1, :);
end