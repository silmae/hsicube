classdef RowMeanTest < matlab.unittest.TestCase
    
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
        
        function meanResultWidth(testCase)
            % Width should be 1 after taking the rowmean
            m = testCase.testCube.rowMean;
            testCase.verifyEqual(m.Width, 1);
        end
        
        function meanPreservesHeight(testCase)
            % Height should not change when taking rowMean
            h = testCase.testCube.Height;
            m = testCase.testCube.rowMean;
            testCase.verifyEqual(m.Height, h);
        end
        
        function rowMeanPreservesBands(testCase)
            % Number of bands should not change
            nb = testCase.testCube.nBands;
            m = testCase.testCube.rowMean;
            testCase.verifyEqual(m.nBands, nb);
        end
        
        function rowMeanIdempotent(testCase)
            % rowMean twice should equal taking the rowMean once
           once  = testCase.testCube.rowMean.Data;
           twice = testCase.testCube.rowMean.rowMean.Data;
           testCase.verifyEqual(twice, once);
        end
    end
end