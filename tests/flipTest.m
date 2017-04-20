% simple [2,3,4] cube for testing
data = cat(3, ones(2,3), 2*ones(2,3), 3*ones(2,3), 4*ones(2,3));
c = Cube(data);

%% Test FlipHorizIdentity
assert(isequal(c.flipHoriz.flipHoriz.Data, data));

%% Test FlipVertIdentity
assert(isequal(c.flipVert.flipVert.Data, data));

