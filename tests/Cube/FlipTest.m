classdef FlipTest < matlab.unittest.TestCase
    
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
        
        function flipHorizDimension(testCase)
            % Horizontal flip flips the data in the second dimension
            flipped = flip(testCase.testCube.Data, 2);
            testCase.verifyEqual(testCase.testCube.flipHoriz.Data, flipped);
        end
        
        function flipVertDimension(testCase)
            % Vertical flip flips the data in the first dimension
            flipped = flip(testCase.testCube.Data, 1);
            testCase.verifyEqual(testCase.testCube.flipVert.Data, flipped);
        end
        
        function flipHorizSelfInverse(testCase)
            % Flipping twice horizontally does nothing
            testCase.verifyEqual(testCase.testCube.flipHoriz.flipHoriz.Data, testCase.testCube.Data);
        end
        
        function flipVertSelfInverse(testCase)
            % Flipping twice vertically does nothing
            testCase.verifyEqual(testCase.testCube.flipVert.flipVert.Data, testCase.testCube.Data);
        end
        
        function flipHorizVertOrder(testCase)
            % Flipping both horizontally and vertically in either order
            % should give the same data.
            testCase.verifyEqual(testCase.testCube.flipVert.flipHoriz.Data, testCase.testCube.flipHoriz.flipVert.Data);
        end
        
    end
end

