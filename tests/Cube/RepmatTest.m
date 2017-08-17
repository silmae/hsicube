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
        
        function repmatResultWidth(testCase, n)
            % Second dimension should multiply the width
            orig = testCase.testCube.Width;
            c = testCase.testCube.repmat([1,n,1]);
            testCase.verifyEqual(c.Width, orig * n);
        end
        
        function repmatResultHeight(testCase, n)
            % First dimension should multiply the height
            orig = testCase.testCube.Height;
            c = testCase.testCube.repmat([n,1,1]);
            testCase.verifyEqual(c.Height, orig * n);
        end
        
        function repmatResultNBands(testCase, n)
            % Third dimension should multiply the bands
            orig = testCase.testCube.nBands;
            c = testCase.testCube.repmat([1,1,n]);
            testCase.verifyEqual(c.nBands, orig * n);
        end
        
    end
end