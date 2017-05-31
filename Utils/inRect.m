function bool = inRect(XY, A, B)
%INRECT True for integer coordinates XY inside the rectangle A-B
% inRect(XY, A, B) returns true for the rows in the Nx2 matrix XY that are
% contained in the rectangle defined by the lower left corner A and
% upper right corner B (B(k) >= A(k)), including the corners.
% Throws an error if any of the matrices contain non-integer values 
% (regardless of numerical type) or if sizes are nonsensical.

% Some sanity checks
assert(size(XY,2) == 2,...
    'XY must be a Nx2 matrix containing N (x,y) pairs as rows');
assert(numel(A)==2 && numel(B) == 2,...
    'Corners must be specified as [x,y] or [x;y] vectors.');
assert(all(isint(XY)),...
    'X, Y coordinates must be integer values');
assert(all(isint(A)) && all(isint(B)),...
    'Rectangle corners must be integer values');
assert(all((B-A) >= 0),...
    'Coordinates of corner B must be greater or equal to those of A');

% Replicate the corners to match the coordinate matrix
N = size(XY,1);
repA = kron(ones(N,1),A);
repB = kron(ones(N,1),B);

% If a row in XY has any value lower than the one in A or greater than one
% in B, the row sum will be positive and that coordinate is outside the
% rectangle.
offA = sum(XY - repA < 0, 2);
offB = sum(repB - XY < 0, 2);

bool = ~offA & ~offB;

end