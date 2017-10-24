classdef Utils
%UTILS Utility functions used by the hsicube package classes

    methods (Static)
        % True for integers of any numeric type
        [bool] = isint(A)
        
        % True for integers > 0
        [bool] = isnatural(a)
        
        % Interpolator for CIE CMF functions
        [XYZ] = CIE_XYZ(wavelengths)
    end
end