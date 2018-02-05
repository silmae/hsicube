classdef NetCDF
%NetCDF A class for writing and reading Cube data to netCDF files.

    methods (Static)
        % Read Cube data from a netCDF file
        [cube] = read(filename, variable);
        
        % Write Cube data to a netCDF file
        [cube] = write(cube, filename);
    end
end