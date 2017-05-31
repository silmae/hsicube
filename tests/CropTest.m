classdef CropTest < matlab.unittest.TestCase
    
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
        function cornerOutOfBounds(testCase)
            % crop should error if given corner is not valid
            c = testCase.testCube;
            
            % 1 is the smallest valid coordinate
            testCase.verifyError(@()c.crop([0 1], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1 0], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1 1], [0 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1 1], [1 0]), 'Cube:CornerOutOfBounds');
            
            % The Cube width and height are the maximum valid coords
            testCase.verifyError(@()c.crop([c.Width+1, 1], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, 1], [c.Width+1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, c.Height+1], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, 1], [1 c.Height+1]), 'Cube:CornerOutOfBounds');
        end
        
        function invalidCorner(testCase)
            % crop should error if the first corner is not to the top left
            % of the second corner
            c = testCase.testCube;
            
            % Not testable on single-pixel data
            testCase.assumeGreaterThan(c.Width, 1);
            testCase.assumeGreaterThan(c.Height, 1);
            
            testCase.verifyError(@()c.crop([2 1], [1 1]), 'Cube:InvalidCorner');
            testCase.verifyError(@()c.crop([1 2], [1 1]), 'Cube:InvalidCorner');
            testCase.verifyError(@()c.crop([2 2], [1 1]), 'Cube:InvalidCorner');
        end
    end
end