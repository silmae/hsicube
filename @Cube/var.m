function obj = var(obj, w, nanflag)
%VAR Spatial variance of the spectra
% var(cube) returns a new cube containing the variance of each
% band.
% var(cube, w)
% var(cube  w, nanflag) can be called to set the weight and the nanflag for
% the calculation, see MATLAB var for details on the parameters.

% Default parameters
if nargin < 2
    w = 0; % normalized by area - 1
end
if nargin < 3
    nanflag = 'includenan'; % include NaN values
end

obj.Data    = var(obj.toList.Data,w,1,nanflag);
obj.History = {{'Reduced to spatial variance',@var}};

end