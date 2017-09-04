classdef HistTest < matlab.unittest.TestCase
    
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
    
    methods ( TestMethodSetup )
          % Suppress figures during tests
          function hideFigures(testCase)
              origSetting = get(0,'DefaultFigureVisible');
              set(0,'DefaultFigureVisible','off');
              testCase.addTeardown(@set, 0, 'DefaultFigureVisible', origSetting);
          end
    end
      
    methods (Test)
        
        function histDataPassThrough(testCase)
            % hist returns the original data without changes as the first
            % return value
            c = testCase.testCube.hist();
            testCase.verifyEqual(c.Data, testCase.testCube.Data)
        end
        
        function histDefaultEdgesFarEnough(testCase)
            % By default hist should use bins that include everything
            c = testCase.testCube;
            [~, ~, edges] = c.hist;
            testCase.verifyGreaterThan(edges(end), c.Max);
            testCase.verifyLessThan(edges(1), c.Min);
        end
        
        function histDefaultEdgesMatchHistcounts(testCase)
            % By default hist should use the default bins that histcounts
            % gives for the whole data
            c = testCase.testCube;
            [~, ~, defaults] = c.hist;
            [~, expected] = histcounts(squeeze(c.byCols.Data));
            testCase.verifyEqual(defaults, expected);
        end
        
        function histDefaultNormalization(testCase)
            % By default hist should return the unnormalized counts
            c = testCase.testCube;
            [~, default] = c.hist;
            [~, expected] = c.hist('count');
            testCase.verifyEqual(default, expected);
        end
        
        function histCountsColSums(testCase)
            % Each column of returned counts should sum to the number of
            % pixels (except in the case of a single pixel)
            c = testCase.testCube;
            testCase.assumeGreaterThan(c.Area, 1);
            [~, counts] = c.hist('count');
            sums = sum(counts, 1);
            expected = ones(1,c.nBands) * c.Area;
            testCase.verifyEqual(sums, expected);
        end
        
        function histProbColSums(testCase)
            % Each column of returned probabilities should sum to 1
            % (within 2 * eps) (except in the case of a single pixel)
            c = testCase.testCube;
            testCase.assumeGreaterThan(c.Area, 1);
            [~, counts] = c.hist('probability');
            sums = sum(counts, 1);
            expected = ones(1,c.nBands);
            testCase.verifyEqual(sums, expected, 'AbsTol', 2*eps);
        end
    end
end