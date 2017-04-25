classdef ConstructorTest < matlab.unittest.TestCase
    % ConstructorTest tests the Cube constructor api and resulting object
    % properties.

    properties 
         % expected default values for missing parameters for the cube
        defaultQuantity       = 'Unknown';
        defaultWavelengthUnit = 'Band index';
        defaultUnknownUnit    = 'Unknown';
        
        % constant test data cube and corresponding metadata
        data = ones(2,3,4,'double');
        wl   = [1 3 5 7];
    end
    
    properties (TestParameter)
        type = {'double', ...
                'single', ...
                'int8',  'uint8',...
                'int16', 'uint16',...
                'int32', 'uint32',...
                'int64', 'uint64'...
                };
        
        % Size parameters
        width  = struct('column', 1, ...
                        'small',  2, ...
                        'large', 10  ...
                        );
        height  = struct('row',    1, ...
                         'small',  2, ...
                         'large', 10  ...
                         );
        bands  = struct('image', 1, ...
                        'rgb',   3, ...
                        'hsi', 100  ...
                        );
        bands2 = struct('image', 1, ...
                        'rgb',   3, ...
                        'hsi',  50  ...
                        );
        % Test metadata
        qty   = {'A', 'Quantity'};
        wlu   = {'nm', 'Wavelength unit'};
    end

    methods (Test)

        function testNullConstructor(testCase)
            % (only) the null constructor should result in empty properties
            nullCube = Cube();
            testCase.verifyEmpty(nullCube.Data);
            testCase.verifyEmpty(nullCube.Bands);
            testCase.verifyEmpty(nullCube.Wavelength);
            testCase.verifyEmpty(nullCube.FWHM);
        end
        
        function testDataIdentity(testCase, width, height, bands, type)
            % Cube should retain the data as is
            cube = ones(height, width, bands, type);
            c = Cube(cube);
            testCase.verifyClass(c.Data, type);
            testCase.verifyEqual(c.Type, type);
        end
        
        function testMetaSize(testCase, width, height, bands)
            % Wavelength, FWHM sizes should match the data and nBands prop.
            cube = ones(height, width, bands);
            c = Cube(cube);
            testCase.verifyLength(c.Wavelength, bands);
            testCase.verifyLength(c.FWHM, bands);
            testCase.verifyEqual(c.nBands, bands);
        end
        
        function testWavelengthMismatch(testCase, width, height, bands, bands2)
            % Mismatched wavelength vector size should result in error
            testCase.assumeNotEqual(bands, bands2);
            cube = ones(height, width, bands);
            wls   = 1:bands2;
            testCase.verifyError(@() Cube(cube, 'wl', wls), 'Cube:IncorrectWavelength');
        end
        
        function testFWHMMismatch(testCase, width, height, bands, bands2)
            % Mismatched fwhm vector size should result in error
            testCase.assumeNotEqual(bands, bands2);
            cube = ones(height, width, bands);
            fwhms   = 1:bands2;
            testCase.verifyError(@() Cube(cube, 'fwhm', fwhms), 'Cube:IncorrectFWHM');
        end
        
        function testDefaultQuantity(testCase)
            c = testCase.verifyWarning(@()Cube(testCase.data), 'Cube:DefaultQuantity');
            testCase.verifyEqual(c.Quantity, testCase.defaultQuantity);
        end
        
        function testDefaultWavelengthUnit(testCase)
            c = testCase.verifyWarning(@()Cube(testCase.data), 'Cube:DefaultWavelengthUnit');
            testCase.verifyEqual(c.WavelengthUnit, testCase.defaultWavelengthUnit);
        end
        
        function testDefaultWavelength(testCase, width, height, bands)
            % Default wavelength vector should be [1, 2, ... , bands]
            cube = ones(height, width, bands);
            c = testCase.verifyWarning(@()Cube(cube), 'Cube:DefaultWavelength');
            testCase.verifyEqual(c.Wavelength, 1:bands);
        end
        
        function testUnknownWavelengthUnit(testCase)
            % If wavelengths are supplied without the unit, it is set to
            % testCase.defaultUnknownUnit with a warning
            c = testCase.verifyWarning(@()Cube(testCase.data, 'wl', testCase.wl), 'Cube:UnknownWavelengthUnit');
            testCase.verifyEqual(c.WavelengthUnit, testCase.defaultUnknownUnit);
        end
        
        function testDefaultFWHM(testCase, width, height, bands)
            % Default FWHM vector should be zeros(1, bands)
            cube = ones(height, width, bands);
            c = testCase.verifyWarning(@()Cube(cube), 'Cube:DefaultFWHM');
            testCase.verifyEqual(c.FWHM, zeros(1,bands));
        end
        
        function testUpdateConstructor_Quantity(testCase)
            c1 = Cube(testCase.data, 'quantity', 'OldQuantity');
            c2 = Cube(c1, 'quantity', 'NewQuantity');

            testCase.verifyEqual(c1.Quantity, 'OldQuantity');
            testCase.verifyEqual(c2.Quantity, 'NewQuantity');
        end
        
        function testUpdateConstructor_WavelengthUnit(testCase)
            c1 = Cube(testCase.data, 'wlunit', 'OldWavelengthUnit');
            c2 = Cube(c1, 'wlunit', 'NewWavelengthUnit');

            testCase.verifyEqual(c1.WavelengthUnit, 'OldWavelengthUnit');
            testCase.verifyEqual(c2.WavelengthUnit, 'NewWavelengthUnit');
        end
        
    end
end