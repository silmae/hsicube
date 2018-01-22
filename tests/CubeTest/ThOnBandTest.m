classdef ThOnBandTest < matlab.unittest.TestCase
    
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
    
    properties (TestParameter)
        thfrac = num2cell(0.2:0.2:0.8);
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
        function thError(testCase)
            % if frac > 1 or < 0, threshold_on_band should error
            
            c = testCase.testCube;
            testCase.verifyError(@()c.threshold_on_band(1, -1), 'Cube:InvalidThreshold');
            testCase.verifyError(@()c.threshold_on_band(1, 2), 'Cube:InvalidThreshold');
            testCase.verifyError(@()c.threshold_on_band(1, 1.1), 'Cube:InvalidThreshold');
            testCase.verifyError(@()c.threshold_on_band(1, inf), 'Cube:InvalidThreshold');
            testCase.verifyError(@()c.threshold_on_band(1, nan), 'Cube:InvalidThreshold');
        end
        
        function minPixels(testCase)
            % thfrac 0 should only keep the minimum valued pixels
            
            c = testCase.testCube.bands(1); % only test on single band
            th_im = c.threshold_on_band(1, 0);
            expected = sum(c.Data(:) ~= c.Min);
            testCase.verifyEqual(sum(th_im(:)), expected);
        end
        
        function noPixels(testCase)
            % thfrac 1 should always give a fully false result.
            
            c = testCase.testCube.bands(1); % only test on single band
            th_im = c.threshold_on_band(1, 1);
            testCase.verifyFalse(all(th_im(:)));
        end
        
    end
end