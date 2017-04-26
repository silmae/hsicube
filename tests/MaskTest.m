classdef MaskTest < matlab.unittest.TestCase
    
    properties
       testCube
       testMask
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
        
        maskseed = {1, 2, 3, 4, 5};
    end
    
    methods (TestClassSetup)
        function createTestData(testCase, width, height, nbands, maskseed)
           % Create a test Cube
           data = gallery('uniformdata', [height, width, nbands], 1);
           % Suppress default value warnings for clearer test output
           warning('off', 'Cube:DefaultQuantity');
           warning('off', 'Cube:DefaultWavelengthUnit');
           warning('off', 'Cube:DefaultWavelength');
           warning('off', 'Cube:DefaultFWHM');
           testCase.testCube = Cube(data);
           % Turn warnings back on
           warning('on', 'all');
           
           % Create a test mask matching in size
           testCase.testMask = logical(gallery('integerdata', [0 1], [height, width], maskseed));
        end
    end
    
    methods (Test)
        
        function maskTypeError(testCase)
            % mask images should be logical matrices
            im = ones(testCase.testCube.Height, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskType');
            
            im = zeros(testCase.testCube.Height, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskType');
        end
        
        function maskShapeError(testCase)
            % mask should error when given a mask with the wrong shape
            im = true(testCase.testCube.Height + 1, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskShape');
            
            im = true(testCase.testCube.Height - 1, testCase.testCube.Width);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskShape');
            
            im = true(testCase.testCube.Height, testCase.testCube.Width + 1);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskShape');
            
            im = true(testCase.testCube.Height, testCase.testCube.Width - 1);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskShape');
            
            % no (> 2)-dimensional masks either
            im = true(testCase.testCube.Height, testCase.testCube.Width, 2);
            testCase.verifyError(@()testCase.testCube.mask(im), 'Cube:InvalidMaskShape');
        end
        
        function maskArea(testCase)
            % Sum of the true pixels in the mask should match the new area
            masked = testCase.testCube.mask(testCase.testMask);
            testCase.verifyEqual(masked.Area, sum(testCase.testMask(:)));
        end
        
        function unMaskGeneralizedInverse(testCase)
            % masking, unmasking and then masking should equal a single mask
            im = testCase.testMask;
            m   = testCase.testCube.mask(im);
            mum = testCase.testCube.mask(im).unmask(im).mask(im);
            testCase.verifyEqual(mum.Data, m.Data);
        end
       
    end
end