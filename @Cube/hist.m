function [obj, counts, edges, h] = hist(obj, normalization, edges, visualize)
%HIST Calculate per-band histograms using the same binning
% [c, counts, bin_edges, h] = HIST(options) calculates a histogram for each
% band and by default displays all the histograms as a surface.
%   
% Outputs:
%   c       : the original datacube
%   counts  : nBins x nBands matrix of histograms
%   edges   : 1 x (nBins+1) vector of bin edges used for the counts
%   h       : handle to the created image (if visualize is true)
%
% Optional parameters:
%   [...] = hist(obj, normalization, edges, visualize)
%
%   normalization: Controls the normalization of the counts per band. 
%     See histcount for valid values. Defaults to count.
%   edges: Bin edges for the histograms. If not given or empty, uses the
%     binning given by histcount on the whole data.
%   visualize: Whether to display the counts using surf. Default true.

% Reorganize the spectra to a 2d array
tmp = squeeze(obj.byCols.Data);

% By default, calculate simple counts for each band
if nargin < 2 || isempty(normalization)
    normalization = 'count';
end

% If no edges were given, let histcounts calculate a binning for the whole
% array
if nargin < 3 || isempty(edges)
    [~, edges] = histcounts(tmp);
end

% Enable visualization by default
if nargin < 4
    visualize = true;
end

% Calculate the set histograms for each band
nBins = length(edges)-1;
counts = zeros(nBins,size(tmp,2));

for ik = 1:size(tmp,2)
    counts(:,ik) = histcounts(tmp(:,ik), edges, 'Normalization', normalization);
end

if visualize
    % Display the counts as an surface in a new figure
    figure
    h = surf(obj.Wavelength, edges(2:end)-0.5*diff(edges), counts, counts);
    h.EdgeColor = 'none';
    h.FaceColor = 'texturemap';
    h.FaceLighting = 'none';
    
    % Default to 2d view
    view(2)
    ax = gca;
    axis tight
    
    % Set labeling
    title([normalization, ' for each band and value']);
    xlabel(ax,obj.WavelengthUnit);
    ylabel(ax,obj.Quantity);
    
    % If brewermap exists in the workspace, use it for the colormap
    if exist('brewermap.m', 'file') == 2
        colormap(brewermap(100, '*GnBu'));
    else
        colormap(parula);
    end
    
    cb = colorbar('eastoutside');
    cb.Label.String = normalization;
end
end