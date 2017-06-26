classdef TakeTest < matlab.unittest.TestCase
    
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
        function takeError(testCase)
            % Take should error for non-natural numbers
            c = testCase.testCube;
            testCase.verifyError(@()c.take(0), 'Cube:InvalidAmount');
            testCase.verifyError(@()c.take(0.1), 'Cube:InvalidAmount');
            testCase.verifyError(@()c.take(-1), 'Cube:InvalidAmount');
            testCase.verifyError(@()c.take(0 + 1i), 'Cube:InvalidAmount');
            testCase.verifyError(@()c.take(nan), 'Cube:InvalidAmount');
            testCase.verifyError(@()c.take(inf), 'Cube:InvalidAmount');
        end
        
        function takeResultWidth(testCase)
            % Width should be 1 after take
            area = testCase.testCube.Area;
            taken = testCase.testCube.take(area);
            testCase.verifyEqual(taken.Width, 1);
        end
        
        function byColsResultHeight(testCase)
            % Height should equal the original area
            area = testCase.testCube.Area;
            taken = testCase.testCube.take(area);
            testCase.verifyEqual(taken.Height, area);
        end
        
        function takePreservesBands(testCase)
            % Number of bands should not change
            nb   = testCase.testCube.nBands;
            taken = testCase.testCube.take(1);
            testCase.verifyEqual(taken.nBands, nb);
        end
        
        function takeOrder(testCase)
            % Taking N from a already taken Cube should give the same
            % pixels as taking N from the whole Cube
            
            N = testCase.testCube.Area;
            testCase.assumeGreaterThan(N,2);
            
            % Pick N-1 spectra from the full cube, then pick N-1 from that
            % and the full cube and check that they match
            all = testCase.testCube.take(N-1);
            fromtaken = all.take(N-2).Data;
            fromfull = testCase.testCube.take(N-2).Data;
            testCase.verifyEqual(fromtaken, fromfull);
        end
    end
end