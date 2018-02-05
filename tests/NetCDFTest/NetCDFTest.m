classdef NetCDFTest < matlab.unittest.TestCase
    
    properties
       testCube
    end
    
    properties (ClassSetupParameter)
        height = struct('row',    1, ...
                        'small',  3, ...
                        'large', 10  ...
                        )
                    
        width  = struct('column', 1, ...
                        'small',  3, ...
                        'large', 10  ...
                        )
                    
        nbands = struct('single',   1, ...
                        'rgb',      3, ...
                        'multi',    5, ...
                        'hyper',  100  ...
                        );
    end

    methods (TestClassSetup)
        function createCube(testCase, width, height, nbands)
           data = gallery('uniformdata', [height, width, nbands], 1);
           wls  = gallery('uniformdata', [1, nbands], 1);
           fwhms= gallery('uniformdata', [1, nbands], 2);
           
           testCase.testCube = Cube(data, ...
               'quantity', 'Testdata',...
               'wlu', 'nm', 'wl', wls, 'fwhm', fwhms);
        end
    end
    
    methods (Test)
        function writeReadDataRoundtrip(testCase)
            % Writing a Cube to NetCDF and reading it back should not change
            % the data.

            orig = testCase.testCube;
            tmpfile = tempname;
            
            NetCDF.write(orig, tmpfile);
            new = NetCDF.read(tmpfile, orig.Quantity);
            delete(tmpfile);
            
            testCase.verifyEqual(new.Data, orig.Data);
        end
        
        function writeReadMetaRoundtrip(testCase)
            % Writing a Cube to NetCDF preserves wavelength and fwhm
            % metadata (up to 6 decimals)
            orig = testCase.testCube;
            tol = 1e-6;
            tmpfile = tempname;
            
            NetCDF.write(orig, tmpfile);
            new = NetCDF.read(tmpfile, orig.Quantity);
            delete(tmpfile);
            
            testCase.verifyEqual(new.WavelengthUnit, orig.WavelengthUnit, 'Wavelength unit changed');
            testCase.verifyLessThan(abs(new.Wavelength - orig.Wavelength), tol, 'Wavelengths changed');
            testCase.verifyLessThan(abs(new.FWHM - orig.FWHM), tol, 'Wavelengths changed');
        end
        
        function writeDataVariableExistsError(testCase)
            % Write should error when an existing variable with the same
            % name exists

            cube = testCase.testCube;
            tmpfile = tempname;
            
            % Create an empty netcdf file with the same variable
            nccreate(tmpfile, cube.Quantity, 'Format', 'netcdf4')
           
            testCase.verifyError(@()NetCDF.write(cube, tmpfile), 'MATLAB:imagesci:netcdf:variableExists');
            delete(tmpfile);
        end
        
        
        function readSuppliedQuantity(testCase)
            % If a quantity is supplied, the Cube returned by NetCDF.read
            % should match the one given
            orig = testCase.testCube;
            tmpfile = tempname;
            
            NetCDF.write(orig, tmpfile);
            new = NetCDF.read(tmpfile, orig.Quantity);
            delete(tmpfile);
            
            testCase.verifyEqual(new.Quantity, orig.Quantity);
        end
    end
end