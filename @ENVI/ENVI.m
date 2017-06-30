classdef ENVI
%ENVI A class for reading/writing ENVI files to Cube format
% This class uses enviread/write functions to read and write ENVI files
% directly to and from Cube objects. Make sure you have the package[1] or
% equivalent version in the MATLAB path.
%
% [1] http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer

    methods (Static)
        % Read Cube data from an ENVI file
        [cube] = read(filenamem, qty);
        
        % Write Cube data to an ENVI file
        [cube] = write(cube, filename, overwrite);
        
        % Find the matching header file for a file
        [hdrfile] = findhdr(filename);
    end
end