function obj = mapSpectra(obj,f,varargin)
%MAPSPECTRA Apply a function on a list of the spectra
% mapSpectra(f,...) applies the function f on the data, reordered as a 
% columnwise matrix of the pixel spectra. The result returned by the 
% function will be reshaped to the original image dimensions, meaning that
% f must necessarily preserve the number of rows in the data (area of the
% cube).
%
% mapSpectra(f, 'Name', 'Value') allows setting new values for the returned 
% Cube metadata. Default values will be generated if not supplied.
% Note that the validity check on the supplied values is done AFTER
% computing f, and if errors occur, the resulting data will be
% lost.

% The data will have a singleton width dimension after byCols,
% so we must deal with it by wrapping the given function.
g = @(x) permute(shiftdim(f(reshape(x, [obj.Area, obj.nBands])), -1), [2 1 3]);

obj = obj.byCols.map(g,varargin{:}).unCols(obj.Width, obj.Height);
end