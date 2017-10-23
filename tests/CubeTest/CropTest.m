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
        
        function cxParams(testCase)
            % crop should accept either a position vector or two corner
            % positions with identical results
            c = testCase.testCube;
            
            % Not testable on single-pixel data
            testCase.assumeGreaterThan(c.Width, 1);
            testCase.assumeGreaterThan(c.Height, 1);
            
            pos = [1,1,1,1];
            tl = [1,1]; 
            br = [2,2];
            testCase.verifyEqual(c.crop(pos).Data, c.crop(tl, br).Data);
        end
        
        function cxSize(testCase)
            % crop should error if not supplied with a single position
            % vector [x,y,w,h] or two corner positions [x,y], [x,y]
            c = testCase.testCube;
            
            testCase.verifyError(@()c.crop([1,1,1]), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.crop([1,1,1,1,1]), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.crop(1,[1,1]), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.crop([1,1],1), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.crop([1,1,1],[1,1]), 'Cube:InvalidCoordinateSize');
            testCase.verifyError(@()c.crop([1,1],[1,1,1]), 'Cube:InvalidCoordinateSize');

        end
        
        function unnaturalCx(testCase)
        	% Coordinates must be integers greater than zero
            c = testCase.testCube;
            
            testCase.verifyError(@()c.crop([0 1], [1 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 0], [1 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 1], [0 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 1], [1 0]), 'Cube:UnnaturalCoordinates');
            
            testCase.verifyError(@()c.crop([1.5 1], [1 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 1.5], [1 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 1], [1.5 1]), 'Cube:UnnaturalCoordinates');
            testCase.verifyError(@()c.crop([1 1], [1 1.5]), 'Cube:UnnaturalCoordinates');
        end
        
        
        function cornerOutOfBounds(testCase)
            % crop should error if given corner is not valid
            c = testCase.testCube;
            
            % The Cube width and height are the maximum valid coords
            testCase.verifyError(@()c.crop([c.Width+1, 1], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, 1], [c.Width+1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, c.Height+1], [1 1]), 'Cube:CornerOutOfBounds');
            testCase.verifyError(@()c.crop([1, 1], [1 c.Height+1]), 'Cube:CornerOutOfBounds');
        end
        
        function invalidCorner(testCase)
            % crop should error if the first corner is not to the top left
            % of the second corner (or equal)
            c = testCase.testCube;
            
            % Not testable on single-pixel data
            testCase.assumeGreaterThan(c.Width, 1);
            testCase.assumeGreaterThan(c.Height, 1);
            
            testCase.verifyError(@()c.crop([2 1], [1 1]), 'Cube:InvalidCornerOrder');
            testCase.verifyError(@()c.crop([1 2], [1 1]), 'Cube:InvalidCornerOrder');
            testCase.verifyError(@()c.crop([2 2], [1 1]), 'Cube:InvalidCornerOrder');
        end
        
        function croppedWidth(testCase)
            % Width of the cropped image should match the distance of the 
            % corner x-coordinates + 1 (inclusive)
            c = testCase.testCube;
            
            testCase.assumeGreaterThan(c.Width, 1);
            
            w = c.Width;
            h = c.Height;
            testCase.verifyEqual(c.crop([1, 1], [w-1, h]).Width, w-1);
            testCase.verifyEqual(c.crop([2, 1], [w, h]).Width, w-1);
        end
        
        function croppedHeight(testCase)
            % Width of the cropped image should match the distance of the 
            % corner x-coordinates + 1 (inclusive)
            c = testCase.testCube;
            
            testCase.assumeGreaterThan(c.Height, 1);
            
            w = c.Width;
            h = c.Height;
            testCase.verifyEqual(c.crop([1, 1], [w, h-1]).Height, h-1);
            testCase.verifyEqual(c.crop([1, 2], [w, h]).Height, h-1);
        end
    end
end