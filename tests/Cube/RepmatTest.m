classdef RepmatTest < matlab.unittest.TestCase
    
    properties
        testCube
    end
    
    properties (TestParameter)
        n = {1,2,3,10}
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
           % Suppress default value warnings for clearer test output
           warning('off', 'Cube:DefaultQuantity');
           warning('off', 'Cube:DefaultWavelengthUnit');
           warning('off', 'Cube:DefaultWavelength');
           warning('off', 'Cube:DefaultFWHM');
           testCase.testCube = Cube(data);
           % Turn warnings back on
           warning('on', 'all');
        end
    end
    
    methods (Test)
        
        function repmatInvalidNsError(testCase)
            % Invalid replication arguments should throw an error
            c = testCase.testCube;
            
            % Only [1,3]-sized vectors should be allowed
            testCase.verifyError(@()c.repmat(2), 'Cube:InvalidNs');
            testCase.verifyError(@()c.repmat([2,2]), 'Cube:InvalidNs');
            testCase.verifyError(@()c.repmat([2;2]), 'Cube:InvalidNs');
            testCase.verifyError(@()c.repmat([2;2;2]), 'Cube:InvalidNs');
            testCase.verifyError(@()c.repmat([2,2;2,2]), 'Cube:InvalidNs');
        end
        
        function repmatResultWidth(testCase, n)
            % Second dimension should multiply the width
            orig = testCase.testCube.Width;
            c = testCase.testCube.repmat([1,n,1]);
            testCase.verifyEqual(c.Width, orig * n);
        end
        
        function repmatResultHeightNBands(testCase, n)
            % Multiplying second dimension should not change height or nbands
            origb = testCase.testCube.nBands;
            origh = testCase.testCube.Height;
            c = testCase.testCube.repmat([1,n,1]);
            testCase.verifyEqual(c.nBands, origb);
            testCase.verifyEqual(c.Height, origh);
        end
        
        function repmatResultHeight(testCase, n)
            % First dimension should multiply the height
            orig = testCase.testCube.Height;
            c = testCase.testCube.repmat([n,1,1]);
            testCase.verifyEqual(c.Height, orig * n);
        end
        
        function repmatResultWidthNBands(testCase, n)
            % Multiplying first dimension should not change width or nbands
            origb = testCase.testCube.nBands;
            origw = testCase.testCube.Width;
            c = testCase.testCube.repmat([n,1,1]);
            testCase.verifyEqual(c.nBands, origb);
            testCase.verifyEqual(c.Width, origw);
        end
        
        function repmatResultNBands(testCase, n)
            % Third dimension should multiply the bands
            orig = testCase.testCube.nBands;
            c = testCase.testCube.repmat([1,1,n]);
            testCase.verifyEqual(c.nBands, orig * n);
        end
        
        function repmatResultWidthHeight(testCase, n)
            % Multiplying third dimension should not change width or height
            origw = testCase.testCube.Width;
            origh = testCase.testCube.Height;
            c = testCase.testCube.repmat([1,1,n]);
            testCase.verifyEqual(c.Width, origw);
            testCase.verifyEqual(c.Height, origh);
        end
        
        function repmatResultWavelength(testCase, n)
            % repeating band dimension should repeat the metadata
            orig = testCase.testCube.Wavelength;
            c = testCase.testCube.repmat([1,1,n]);
            testCase.verifyEqual(c.Wavelength, repmat(orig, [1,n]));
        end
        
        function repmatWidthWavelength(testCase, n)
            % repeating second dimension should preserve the metadata
            orig = testCase.testCube.Wavelength;
            c = testCase.testCube.repmat([1,n,1]);
            testCase.verifyEqual(c.Wavelength, orig);
        end
        
        function repmatHeightWavelength(testCase, n)
            % repeating first dimension should preserve the metadata
            orig = testCase.testCube.Wavelength;
            c = testCase.testCube.repmat([n,1,1]);
            testCase.verifyEqual(c.Wavelength, orig);
        end
        
        function repmatResultFWHM(testCase, n)
            % repeating band dimension should repeat the metadata
            orig = testCase.testCube.FWHM;
            c = testCase.testCube.repmat([1,1,n]);
            testCase.verifyEqual(c.FWHM, repmat(orig, [1,n]));
        end
        
        function repmatWidthFWHM(testCase, n)
            % repeating second dimension should preserve the metadata
            orig = testCase.testCube.FWHM;
            c = testCase.testCube.repmat([1,n,1]);
            testCase.verifyEqual(c.FWHM, orig);
        end
        
        function repmatHeightFWHM(testCase, n)
            % repeating first dimension should preserve the metadata
            orig = testCase.testCube.FWHM;
            c = testCase.testCube.repmat([n,1,1]);
            testCase.verifyEqual(c.FWHM, orig);
        end
    end
end