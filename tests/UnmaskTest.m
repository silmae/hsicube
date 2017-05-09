classdef UnmaskTest < matlab.unittest.TestCase
    
    properties
       testCube
       testMask
    end
    
    properties (ClassSetupParameter)
        height = struct('row',    1, ...
                        'small',  3, ...
                        'large', 10  ...
                        );
                    
        width  = struct('column', 1, ...
                        'small',  3, ...
                        'large', 10  ...
                        );
                    
        nbands = struct('single',   1, ...
                        'rgb',      3, ...
                        'multi',    5, ...
                        'hyper',  100  ...
                        );
        
        maskseed = {1, 2, 3, 4, 5};
    end
    
    methods (TestClassSetup)
        function createTestData(testCase, width, height, nbands, maskseed)
           % Create a test mask
           testCase.testMask = logical(gallery('integerdata', [0 1], [height, width], maskseed));
           
           % Create a Cube with matching data that can be unmasked
           data = gallery('uniformdata', [sum(testCase.testMask(:)), 1, nbands], 1);
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
        
        function maskTypeError(testCase)
            % mask images should be logical matrices
            im = ones(testCase.testCube.Height, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.unmask(im), 'Cube:InvalidMaskType');
            
            im = zeros(testCase.testCube.Height, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.unmask(im), 'Cube:InvalidMaskType');
        end
        
        function maskShapeError(testCase)
            % no (> 2)-dimensional masks
            im = true(testCase.testCube.Height, testCase.testCube.Width, 2);
            testCase.verifyError(@()testCase.testCube.unmask(im), 'Cube:InvalidMaskShape');
        end
        
        function unmaskAreaTooSmall(testCase)
            % An error should be thrown if sum(mask) is less than the area
            % of the cube
            testCase.assumeGreaterThan(testCase.testCube.Area,0);
            
            invalidMask = [true(1, testCase.testCube.Area - 1), false];
            testCase.verifyError(@()testCase.testCube.unmask(invalidMask),'Cube:InvalidMaskArea');
            
            invalidMask = [false, true(1, testCase.testCube.Area - 1)];
            testCase.verifyError(@()testCase.testCube.unmask(invalidMask),'Cube:InvalidMaskArea');
            
            % Same error should result if the mask is too small alltogether
            invalidMask = true(1, testCase.testCube.Area - 1);
            testCase.verifyError(@()testCase.testCube.unmask(invalidMask),'Cube:InvalidMaskArea');
        end
        
        function unmaskAreaTooLarge(testCase)
            % An error should be thrown if sum(mask) is greater than the
            % area of the cube
            invalidMask = true(1, testCase.testCube.Area + 1);
            testCase.verifyError(@()testCase.testCube.unmask(invalidMask),'Cube:InvalidMaskArea');
        end
        
        function unmaskDimensions(testCase)
            % Dimensions of the unmasked cube should equal the mask
            [h, w] = size(testCase.testMask);
            testCase.verifyEqual(testCase.testCube.unmask(testCase.testMask).Width, w);
            testCase.verifyEqual(testCase.testCube.unmask(testCase.testMask).Height, h);
        end
        
        function unmaskZeroes(testCase)
            % False values in mask should result in filled-in zero pixels
            expectedZero = repmat(~testCase.testMask, [1, 1, testCase.testCube.nBands]);
            unmasked = testCase.testCube.unmask(testCase.testMask).Data;
            testCase.verifyTrue(all(unmasked(expectedZero) == 0));
        end
            
        function maskInverse(testCase)
            % mask should be an inverse of an unmask
            im = testCase.testMask;
            orig = testCase.testCube.Data;
            new  = testCase.testCube.unmask(im).mask(im).Data;
            testCase.verifyEqual(new, orig);
        end
       
    end
end