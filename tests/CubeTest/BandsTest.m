classdef BandsTest < matlab.unittest.TestCase
    
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
        function bandsByCopy(testCase)
            % selecting bands returns a copy, does not change original
            testCase.assumeNotEqual(testCase.testCube.nBands, 1);
            
            data = testCase.testCube.Data;
            wl = testCase.testCube.Wavelength;
            fwhm = testCase.testCube.FWHM;
            new = testCase.testCube.bands(1);
            
            testCase.verifyEqual(testCase.testCube.Data, data);
            testCase.verifyEqual(testCase.testCube.Wavelength, wl);
            testCase.verifyEqual(testCase.testCube.FWHM, fwhm);
            
            testCase.verifyNotEqual(new.Data, data);
            testCase.verifyNotEqual(new.Wavelength, wl);
            testCase.verifyNotEqual(new.FWHM, fwhm);
        end
        
        function outOfRangeError(testCase)
            % Valid indices are in the range 1:nBands
            testCase.verifyError(@()testCase.testCube.bands(-1), 'Cube:BandOutOfRange');
            testCase.verifyError(@()testCase.testCube.bands(0), 'Cube:BandOutOfRange');
            testCase.verifyError(@()testCase.testCube.bands(testCase.testCube.nBands+1), 'Cube:BandOutOfRange');
            testCase.verifyError(@()testCase.testCube.bands(0:testCase.testCube.nBands), 'Cube:BandOutOfRange');
            testCase.verifyError(@()testCase.testCube.bands(1:testCase.testCube.nBands+1), 'Cube:BandOutOfRange');
            testCase.verifyError(@()testCase.testCube.bands([1, -1]), 'Cube:BandOutOfRange');
        end
        
        function invalidIdxError(testCase)
            % Invalid single values should error
            testCase.verifyError(@()testCase.testCube.bands(1.5), 'Cube:InvalidBandIdx');
            testCase.verifyError(@()testCase.testCube.bands(1 + 1i), 'Cube:InvalidBandIdx');
            testCase.verifyError(@()testCase.testCube.bands(nan), 'Cube:InvalidBandIdx');
            testCase.verifyError(@()testCase.testCube.bands(inf), 'Cube:InvalidBandIdx');
        end
        
        function invalidIdxVectorError(testCase)
            % Vectors containing invalid values should error
            testCase.verifyError(@()testCase.testCube.bands([1, 1.5]), 'Cube:InvalidBandIdx');
            testCase.verifyError(@()testCase.testCube.bands([1, 1 + 1i]), 'Cube:InvalidBandIdx');
            
            testCase.verifyError(@()testCase.testCube.bands([1, nan]), 'Cube:InvalidBandIdx');
            testCase.verifyError(@()testCase.testCube.bands([1, inf]), 'Cube:InvalidBandIdx');
        end
        
        function invalidIdxShapeError(testCase)
            % non-vector matrices are invalid whether or not they contain 
            % valid indices or logical values
            testCase.verifyError(@()testCase.testCube.bands(zeros(2)), 'Cube:InvalidIdxShape');
            testCase.verifyError(@()testCase.testCube.bands(ones(2)), 'Cube:InvalidIdxShape');
            testCase.verifyError(@()testCase.testCube.bands(true(2)), 'Cube:InvalidIdxShape');
            testCase.verifyError(@()testCase.testCube.bands(false(2)), 'Cube:InvalidIdxShape');
        end
        
        function invalidLogicalIdxError(testCase)
            % logical vectors of incorrect length should error
            testCase.verifyError(@()testCase.testCube.bands(true(1, testCase.testCube.nBands+1)), 'Cube:InvalidLogicalIdx');
            testCase.verifyError(@()testCase.testCube.bands(true(1, testCase.testCube.nBands-1)), 'Cube:InvalidLogicalIdx');
            testCase.verifyError(@()testCase.testCube.bands(false(1, testCase.testCube.nBands+1)), 'Cube:InvalidLogicalIdx');
            testCase.verifyError(@()testCase.testCube.bands(false(1, testCase.testCube.nBands-1)), 'Cube:InvalidLogicalIdx');
        end
        
        function bandsIdentity(testCase)
            % Selecting all bands shouldn't change anything
            all = testCase.testCube.bands(1:testCase.testCube.nBands);

            testCase.verifyEqual(all.Data, testCase.testCube.Data); 
            testCase.verifyEqual(all.Wavelength, testCase.testCube.Wavelength);
            testCase.verifyEqual(all.FWHM, testCase.testCube.FWHM);
        end
        
        function bandDataOrder(testCase)
            % Each selected band should match the original band
            for k = 1:testCase.testCube.nBands
                selected = testCase.testCube.bands(k);
                testCase.verifyEqual(selected.Data, testCase.testCube.Data(:,:,k)); 
                testCase.verifyEqual(selected.Wavelength, testCase.testCube.Wavelength(k));
                testCase.verifyEqual(selected.FWHM, testCase.testCube.FWHM(k));
            end
        end
        
        function returnIdxFormat(testCase)
            % [~, b2] = bands(b1) should return b1 as indices even when
            % selected using logical indexing.
            [~, b] = testCase.testCube.bands(true(1,testCase.testCube.nBands));
            testCase.verifyEqual(b, 1:testCase.testCube.nBands);
        end
    end
end