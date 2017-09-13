classdef fromListTest < matlab.unittest.TestCase
    
    properties
        testCube
        w
        h
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
           % Create a tabular Cube (list of pixels)
           data = gallery('uniformdata', [height * width, 1, nbands], 1);
           % Suppress default value warnings for clearer test output
           warning('off', 'Cube:DefaultQuantity');
           warning('off', 'Cube:DefaultWavelengthUnit');
           warning('off', 'Cube:DefaultWavelength');
           warning('off', 'Cube:DefaultFWHM');
           testCase.testCube = Cube(data);
           % Store the width and height for testing valid combinations
           testCase.w = width;
           testCase.h = height;
           % Turn warnings back on
           warning('on', 'all');
        end
    end
    
    methods (Test)
        function fromListInvalidCubeError(testCase)
            % fromList should error if the current Cube is not a list
            % (width 1, height N).
            % Test this by attempting to fromList twice on cubes with
            % width > 1
            testCase.assumeGreaterThan(testCase.w, 1);
            c = testCase.testCube.fromList(testCase.w, testCase.h);
            testCase.verifyError(@()c.fromList(testCase.w, testCase.h), 'Cube:NotAList');
        end
        
        function fromListInvalidAreaError(testCase)
            % fromList should error if the new area does not match the number
            % of pixels in the Cube
            c = testCase.testCube;
            goodw= testCase.w;
            goodh = testCase.h;
            testCase.verifyError(@()c.fromList(goodw-1, goodh), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw, goodh-1), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw-1, goodh-1), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw+1, goodh), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw, goodh+1), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw+1, goodh+1), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(0, goodh), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw, 0), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(-1, goodh), 'Cube:InvalidArea');
            testCase.verifyError(@()c.fromList(goodw, -1), 'Cube:InvalidArea');
        end
        
        function fromListResultWidth(testCase)
            % Width should be the given one after fromList
            c = testCase.testCube;
            d = c.fromList(testCase.w, testCase.h);
            testCase.verifyEqual(d.Width, testCase.w);
        end
        
        function fromListResultHeight(testCase)
            % Height should be the given one after fromList
            c = testCase.testCube;
            d = c.fromList(testCase.w, testCase.h);
            testCase.verifyEqual(d.Height, testCase.h);
        end
        
        function fromListPreservesBands(testCase)
            % Number of bands should not change
            c = testCase.testCube;
            nb = c.nBands;
            cube = testCase.testCube.fromList(testCase.w, testCase.h);
            testCase.verifyEqual(cube.nBands, nb);
        end
        
        function fromListtoListInverse(testCase)
            % fromList should be an inverse of toList
            orig = testCase.testCube.Data;
            new  = testCase.testCube.fromList(testCase.w, testCase.h).toList.Data;
            testCase.verifyEqual(new, orig);
        end
    end
end