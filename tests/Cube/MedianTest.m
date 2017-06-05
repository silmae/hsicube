classdef MedianTest < matlab.unittest.TestCase
    
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
        
        function medianResultWidth(testCase)
            % Width should be 1 after taking the median
            m = testCase.testCube.median;
            testCase.verifyEqual(m.Width, 1);
        end
        
        function medianResultHeight(testCase)
            % Height should be 1 after taking the median
            m = testCase.testCube.median;
            testCase.verifyEqual(m.Height, 1);
        end
        
        function medianPreservesBands(testCase)
            % Number of bands should not change
            nb   = testCase.testCube.nBands;
            m = testCase.testCube.median;
            testCase.verifyEqual(m.nBands, nb);
        end
        
        function medianIdempotent(testCase)
            % median twice should equal taking the median once
           once  = testCase.testCube.median.Data;
           twice = testCase.testCube.median.median.Data;
           testCase.verifyEqual(twice, once);
        end
    end
end