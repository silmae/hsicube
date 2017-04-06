function [obj,h] = im(obj,b,hlx,hly)
%IM Display a single band from the cube
% im(band) displays the given band using imagesc (default b = 1).
% im(band, x, y)
% im(band, [x,y]) 
% with x and y pixel coordinates, hilights the given pixels in the image.
% 
% Returns obj.bands(b) and the handle to the image.

if nargin < 2
    b = 1;
end
if nargin < 3
    hlx = zeros(1,2); % FIXME: Don't use zeros as a special value
end
if nargin < 4
    hly = hlx(:,2);
    hlx = hlx(:,1);
end
assert(isscalar(b) && ~isempty(intersect(b,obj.Bands)),...
       'Band number must be a single scalar in the range %d-%d.',1,obj.nBands);
obj = obj.bands(b);
h = imagesc(obj.Data);
if hlx~=0 % FIXME: Don't use zeros as a special value
    if obj.inIm(hlx,hly)
        hold on
        scatter(hlx,hly);
        hold off
    else
        warning('Given pixels are not in the image area (1,1)-(%d,%d) and are not shown.',...
                obj.Width,obj.Height);
    end
end
end
