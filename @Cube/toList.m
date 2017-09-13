function obj = toList(obj)
%TOLIST Reshape the Cube to a list of spectra
% c2 = c1.toList reshapes the W x H x Bands Cube c1 to an
% (W * H) x 1 x Bands cube c2. The spectra are ordered in column-first
% order (MATLAB default).
% 
% See also: FROMLIST, MASK, UNMASK

obj.Data    = reshape(obj.Data,[obj.Area,1,obj.nBands]);
obj.History = {{'Reshaped to a list',@toList}};

end