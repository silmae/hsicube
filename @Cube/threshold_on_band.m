function [th_im] = threshold_on_band(obj, band, th_frac)
%THRESHOLD_ON_BAND Segment the cube based on a single band
% bin_im = threshold_on_band(cube, band, frac) returns a segmentation
% (logical matrix) of the given band with value true for each pixel having a
% strictly higher value than th_frac of the pixels in the band ((1-thfrac) 
% quantile), and false for lower.
%
% th_frac must be between 0 (all but min. values included) and 1
% (fully false result).
% 
% See also: mask

assert(th_frac <= 1 && th_frac >= 0, ...
    'Cube:InvalidThreshold', ...
    sprintf('Supplied fraction must be between 0 and 1, %d was supplied', th_frac));

% this is handled separately since 'find' wwwill produce an empty result
if th_frac == 1
    th_im = false(obj.Height, obj.Width);
    return
end

% We only need the single band
c = obj.bands(band);

% Select binning based on the data
switch c.Type
    case 'uint8'
        bins = 0:255;
    case 'uint16'
        bins = 0:65535;
    otherwise
        bins = linspace(c.Min, c.Max, max(2,c.Area)); % max for edge cases
end

% Calculate the cumulative histogram of the band
[~, ccounts, ~] = ...
    c.hist('cdf', bins, false);

% Find the index corresponding to the threshold
k = find(ccounts > th_frac,1);

% Threshold using the bin edge (inclusive)
th_im = squeeze(c.Data > bins(k));
end