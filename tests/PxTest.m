classdef PxTest < matlab.unittest.TestCase
    
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
        
        function cxSize(testCase)
            % Argument must be a N x 2 matrices, else error
            c = testCase.testCube;
            
            testCase.verifyError(@()c.px(1), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.px([1;1]), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.px([1,1,1]), 'Cube:InvalidCoordinateSize');
        end
        
        function unnaturalCx(testCase)
        	% Coordinates must be integers greater than zero
            c = testCase.testCube;
            
            testCase.verifyError(@()c.px([0 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.px([1 0]), 'Cube:UnnaturalCoordinates');
            
            testCase.verifyError(@()c.px([1.5 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.px([1 1.5]), 'Cube:UnnaturalCoordinates');
        end
        
        function cxOutOfBounds(testCase)
            % px should error if a given coordinate is not valid
            c = testCase.testCube;
            
            % The Cube width and height are the maximum valid coords
            testCase.verifyError(@()c.px([c.Width+1, 1]), 'Cube:CoordinateOutOfBounds');
            testCase.verifyError(@()c.px([1, c.Height+1]), 'Cube:CoordinateOutOfBounds');
            testCase.verifyError(@()c.px([c.Width+1, c.Height+1]), 'Cube:CoordinateOutOfBounds');
        end
        
        function resultArea(testCase)
            % px should return as many pixels as were supplied (including
            % duplicates)
            c = testCase.testCube;
            
            cx = [1,1];
            testCase.verifyEqual(c.px(cx).Area, 1);
            
            cx = [1, 1; ...
                  1, 1];
            testCase.verifyEqual(c.px(cx).Area, 2);
            
            cx = [1:min(c.Width, c.Height); 1:min(c.Width, c.Height)]';
            testCase.verifyEqual(c.px(cx).Area, size(cx,1));
        end
    end
end