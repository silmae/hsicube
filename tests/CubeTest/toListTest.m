classdef toListTest < matlab.unittest.TestCase
    
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
        
        function toListResultWidth(testCase)
            % Width should be 1 after toList
            cols = testCase.testCube.toList;
            testCase.verifyEqual(cols.Width, 1);
        end
        
        function toListResultHeight(testCase)
            % Height should equal the original area
            area = testCase.testCube.Area;
            cols = testCase.testCube.toList;
            testCase.verifyEqual(cols.Height, area);
        end
        
        function toListPreservesBands(testCase)
            % Number of bands should not change
            nb   = testCase.testCube.nBands;
            cols = testCase.testCube.toList;
            testCase.verifyEqual(cols.nBands, nb);
        end
        
        function toListIdempotent(testCase)
            % toList twice should equal toList once
           once  = testCase.testCube.toList.Data;
           twice = testCase.testCube.toList.toList.Data;
           testCase.verifyEqual(twice, once);
        end
        
        function toListfromListInverse(testCase)
            % fromList should be an inverse of toList
            orig = testCase.testCube.Data;
            w = testCase.testCube.Width;
            h = testCase.testCube.Height;
            new  = testCase.testCube.toList.fromList(w, h).Data;
            testCase.verifyEqual(new, orig);
        end
    end
end