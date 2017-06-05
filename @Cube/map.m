function obj = map(obj,f,varargin)
%MAP Applies the given function on the cube data
% map(f,...) applies the function f on
% the data and returns a cube with the resulting data. 
%
% map(f,'Name', 'Value) allows setting new metadata for the resulting Cube.
% Note that the validity check on the supplied values is done AFTER
% computing f. If this results in an error, the result is not
% returned.

assert(isa(f,'function_handle'),...
     'Cube:InvalidFunction', ...
     'Expected a valid function handle');

% Hope for the best and let the constructor fail on any inconsistencies.
g = f(obj.Data);
obj = Cube(g, varargin{:});
end