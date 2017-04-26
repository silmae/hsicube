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
                    
    end

    properties (MethodSetupParameter)
        maskseed = {1, 2, 3, 4, 5};
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
    
    methods (TestMethodSetup)
        function createMask(testCase, maskseed)
            testCase.testMask = logical(gallery('integerdata', [0 1], [testCase.testCube.Height, testCase.testCube.Width], maskseed));
        end
    end
    
    methods (Test)
        
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