classdef ColMeanTest < matlab.unittest.TestCase
    
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
        
        function colMeanpreservesWidth(testCase)
            % Width should not change when taking the column mean
            w = testCase.testCube.Width;
            m = testCase.testCube.colMean;
            testCase.verifyEqual(m.Width, w);
        end
        
        function colMeanResultHeight(testCase)
            % Height should be 1 after taking the colMean
            m = testCase.testCube.colMean;
            testCase.verifyEqual(m.Height, 1);
        end
        
        function colMeanPreservesBands(testCase)
            % Number of bands should not change
            nb = testCase.testCube.nBands;
            m = testCase.testCube.colMean;
            testCase.verifyEqual(m.nBands, nb);
        end
        
        function colMeanIdempotent(testCase)
            % colMean twice should equal taking the colMean once
           once  = testCase.testCube.colMean.Data;
           twice = testCase.testCube.colMean.colMean.Data;
           testCase.verifyEqual(twice, once);
        end
    end
end