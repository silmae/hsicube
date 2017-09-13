function obj = mean(obj, flag1, flag2)
%MEAN Returns the spatial mean spectra.
% mean('omitnan'), mean('omitinf') or mean('omitinf','omitnan')
% may be used to omit NaN, Inf or both values.

if nargin < 2
    % Just calculate the mean
    obj.Data    = mean(obj.toList.Data,1);
    obj.History = {{'Reduced to spatial mean',@mean}};
elseif nargin < 3
    if strcmp(flag1, 'omitinf')
        % Convert inf to nan, and use the flag in mean
        obj.Data(isinf(obj.Data)) = nan;
        obj.Data = mean(obj.toList.Data,1,'omitnan');
    elseif strcmp(flag1, 'omitnan')
        % For NaN, mean() has us covered
        obj.Data    = mean(obj.toList.Data,1, flag1);
    else
        error('Flag not recognized.\nPass "omitinf", "omitnan" or both to omit respective values from the mean.');
    end
    obj.History = {{'Reduced to spatial mean',@mean, flag1}};
elseif nargin == 3 && ...
        ((strcmp(flag1,'omitinf') && strcmp(flag2, 'omitnan')) ||...
        (strcmp(flag2,'omitinf') && strcmp(flag1, 'omitnan')))
    obj.Data = obj.toList.Data;
    obj.Data = mean(obj.Data(obj.Data < inf),1,'omitnan');
    obj.History = {{'Reduced to spatial mean',@mean, flag1,flag2}};
else
    error('Flags not recognized.\nPass "omitinf", "omitnan" or both to omit respective values from the mean.');
end

end