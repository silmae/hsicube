function obj = mapSpectra(obj,f,history,qty,wlunit,wls,fwhm)
%MAPSPECTRA Apply a function on a list of the spectra
% mapSpectra(f,history,qty,wlunit,wls,fwhm) applies the function
% f on the data, reordered as a columnwise matrix of the pixel
% spectra. The result returned by the function will be reshaped
% to the original image dimensions. The user must supply an
% explanatory history string to be included in the result history.
% The user must supply a new quantity, wavelengths, fwhms and
% wavelength unit that correspond to the new data. Note that
% a validity check on the supplied values is done AFTER
% computing f, and if errors occur, the resulting data will be
% lost. Note that f must preserve the area of the image.

% The data will have a singleton width dimension after byCols,
% so we must deal with it by wrapping the given function.
g = @(x) permute(shiftdim(f(reshape(x, [obj.Area, obj.nBands])), -1), [2 1 3]);

obj = obj.byCols.map(g,history,qty,wlunit,wls,fwhm).unCols(obj.Width, obj.Height);
end