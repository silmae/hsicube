classdef MapBandsTest < matlab.unittest.TestCase
    
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

    properties (TestParameter)
        % Valid functions to test
        fs = struct('id', @(x) x, ...
            'square', @(x) x.*x, ...
            'neg', @(x) -x, ...
            'flipY', @(x)flip(x,2), ...
            'flipX', @(x)flip(x,1), ...
            'constScalar', @(x) 1, ...
            'constMatrix', @(x) ones(3,3) ...
            );
    end
    
    methods (TestClassSetup)
        function createCube(testCase, width, height, nbands)
           data = gallery('uniformdata', [height, width, nbands], 1);
           wls  = gallery('uniformdata', [1, nbands], 1);
           fwhms= gallery('uniformdata', [1, nbands], 2);
           
           testCase.testCube = Cube(data, ...
               'quantity', 'Testdata',...
               'wlu', 'nm', 'wl', wls, 'fwhm', fwhms);
        end
    end
    
    methods (Test)
        function idMapBands(testCase)
            % mapBands(id) should not change the data
            id = @(x) x;
            orig = testCase.testCube;
            new = orig.mapBands(id);
            
            testCase.verifyEqual(new.Data, orig.Data);
        end
        
        function defaultQuantity(testCase, fs)
            % If no new quantity was supplied, result quantity should be 
            % 'Unknown'
            orig = testCase.testCube;
            new = orig.mapBands(fs);
            
            testCase.verifyEqual(new.Quantity, 'Unknown');
        end
        
        function suppliedQuantity(testCase, fs)
            % If a new quantity was supplied, result quantity should be 
            % set to the given value
            orig = testCase.testCube;
            qty = orig.Quantity;
            new = orig.mapBands(fs, qty);
            
            testCase.verifyEqual(new.Quantity, qty);
        end
        
        function bandNumber(testCase, fs)
            % mapBands preserves nBands
            orig = testCase.testCube;
            new = orig.mapBands(fs);
            
            testCase.verifyEqual(new.nBands, orig.nBands);
        end
    end
end