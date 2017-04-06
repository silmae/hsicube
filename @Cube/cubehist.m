function [obj, counts, bin_edges, h] = cubehist(obj, flag, showPlot, bin_edges)
%CUBEHIST Plot histograms of the spectra using a colormap
% cubehist() calculates a histogram for each band and displays them as an
%   image with the counts mapped to colors.
%   You can pass a flag to indicate whether you want logarithmic or linear
%   counts:
%   cubehist('log') (default)
%   cubehist('linear')
%
% [c, h, counts] = c.cubehist(...)
% returns the cube (unchanged), figure handle and the counts matrix.

% Copyright 2017 Ilkka Pölönen
%                Matti A. Eskelinen

if nargin < 2
    flag = 'log';
else
    assert(strcmp(flag,'log') || strcmp(flag, 'linear') || strcmp(flag, 'cum'),...
        'Flag not recognized. Pass "log" or "linear" to select the scaling, or "cum" for a cumulative histogram.');
end

if nargin < 3
    showPlot = true;
end

% If bin_edges not given, use a fixed 1000 bins between the min and max 
% values, or [0 1] if the data is between 0 and 1

if nargin < 4
    nBins = 1000;
    if obj.Normalized
        bin_edges = linspace(0, 1, nBins+1);
    else
        bin_edges = linspace(obj.Min, obj.Max, nBins+1);
    end
else
    nBins = length(bin_edges)-1;
end

% Reorganize the spectra
tmp = squeeze(obj.byCols.Data);

% Histogram for each band
counts = zeros(size(tmp,2),nBins);
if strcmp(flag, 'cum')
    norm = 'cumcount';
else
    norm = 'count';
end

for ik = 1:size(tmp,2)
    counts(ik,:) = histcounts(tmp(:,ik),bin_edges,'Normalization', norm);
end

% Normalization of histogram
if strcmp(flag, 'log')
    counts = log(counts)./size(tmp,1);
elseif strcmp(flag, 'linear')
    counts = counts./size(tmp,1);
end

if showPlot
    % Display the counts as an image
    h = imagesc(rot90(counts));
    ax = gca;
    ax.YTick = [1, nBins];
    ax.YTickLabel = num2str(bin_edges(0), bin_edges(end));
%     if obj.Normalized
%         ax.YTickLabel = num2str([1; 0]);
%     else
%         ax.YTickLabel = num2str([obj.Max; obj.Min]);
%     end
    
    % If brewermap exists in the workspace, we use it for the colormap
    if exist('brewermap.m', 'file') == 2
        colormap(brewermap(100, '*GnBu'));
    else
        colormap(parula);
    end
    if length(obj.Wavelength) < 1
        ax.XTickLabels = num2str(obj.Wavelength(ax.XTick)');
        xlabel(ax,{'Wavelength',obj.Wavelength_Unit});
    end
    ylabel(ax,obj.Quantity);
    cb = colorbar('eastoutside');
    
    if strcmp(flag, 'log')
        cb.YLabel.String = 'log(counts)';
    elseif strcmp(flag,'linear')
        cb.YLabel.String = 'counts';
    end
end
end