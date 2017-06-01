classdef ENVI
    methods (Static)
        % Read Cube data from an ENVI file
        [cube] = read(filenamem, qty);
        
        % Write Cube data to an ENVI file
        [cube] = write(cube, filename);
        
        % Find the matching header file for a file
        [hdrfile] = findhdr(filename);
    end
end