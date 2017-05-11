classdef ByColsTest < matlab.unittest.TestCase
    
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
        
        function byColsResultWidth(testCase)
            % Width should be 1 after byCols
            cols = testCase.testCube.byCols;
            testCase.verifyEqual(cols.Width, 1);
        end
        
        function byColsResultHeight(testCase)
            % Height should equal the original area
            area = testCase.testCube.Area;
            cols = testCase.testCube.byCols;
            testCase.verifyEqual(cols.Height, area);
        end
        
        function byColsPreservesBands(testCase)
            % Number of bands should not change
            nb   = testCase.testCube.nBands;
            cols = testCase.testCube.byCols;
            testCase.verifyEqual(cols.nBands, nb);
        end
        
        function byColsIdempotent(testCase)
            % byCols twice should equal byCols once
           once  = testCase.testCube.byCols.Data;
           twice = testCase.testCube.byCols.byCols.Data;
           testCase.verifyEqual(twice, once);
        end
        
        function byColsUnColsInverse(testCase)
            % unCols should be an inverse of byCols
            orig = testCase.testCube.Data;
            w = testCase.testCube.Width;
            h = testCase.testCube.Height;
            new  = testCase.testCube.byCols.unCols(w, h).Data;
            testCase.verifyEqual(new, orig);
        end
    end
end