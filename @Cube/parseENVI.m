function obj = parseENVI(obj, S)
%PARSEENVI assigns metadata from ENVI header struct
% parseENVI(S) cleans up and assigns metadata fields from the
% given struct (from enviread/read_envihdr).
%
% TODO: Implement this as a modified read_envihdr
% TODO: Implement using a public, static method (?)

% Units aren't specified by the Specim NIR camera header
if isfield(S,'wavelength_units')
    obj.Wavelength_Unit = S.wavelength_units;
else
    warning('Wavelength units not specified!');
    obj.Wavelength_Unit = 'Unknown';
end

% Differing capitalization between Specim and VTT cameras
if isfield(S,'wavelength')
    obj.Wavelength = str2num(S.wavelength(2:end-1));
elseif isfield(S,'Wavelength')
    obj.Wavelength = str2num(S.Wavelength(2:end-1));
else
    warning('Wavelength information not specified!');
    obj.Wavelength = zeros(1,obj.nBands);
end

% This is checked just for posterity (hopefully)
if isfield(S,'fwhm')
    obj.FWHM = str2num(S.fwhm(2:end-1));
else
    warning('FWHM information not specified!');
    obj.FWHM = zeros(1,obj.nBands);
end

obj.History = {{'Parsed ENVI metadata',@parseENVI,S}};
end