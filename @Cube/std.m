function [obj] = std(obj, w, nanflag)
%STD Spatial standard deviation of the spectra
% std(cube) returns a new cube containing the standard deviation of each
% band.
% std(cube, w)
% std(cube  w, nanflag) can be called to set the weight and the nanflag for
% the calculation, see MATLAB var for details on the parameters.

% Default parameters
if nargin < 2
    w = 0; % normalized by area - 1
end
if nargin < 3
    nanflag = 'includenan'; % include NaN values
end

obj.Data    = std(obj.toList.Data,w,1,nanflag);
obj.History = {{'Reduced to spatial variance',@var}};

end