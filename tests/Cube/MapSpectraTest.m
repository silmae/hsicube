classdef MapSpectraTest < matlab.unittest.TestCase
    
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
        % Functions to test
        fs = struct('id', @(x) x, ...
            'square', @(x) x.*x, ...
            'neg', @(x) -x, ...
            'reverse', @reverse, ...
            'ends', @(x) [x(1),x(end)]);
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
        function spatialDimensions(testCase, fs)
            % mapSpectra preserves the spatial dimensions
            orig = testCase.testCube;
            new = orig.mapSpectra(fs);
            
            testCase.verifyEqual(new.Width, orig.Width, 'Width changed');
            testCase.verifyEqual(new.Height, orig.Height, 'Height changed');
        end
        
        function byColsCommutation(testCase, fs)
            % mapSpectra and byCols should commute
            orig = testCase.testCube; 
            
            first = orig.mapSpectra(fs).byCols;
            second = orig.byCols.mapSpectra(fs);
            
            testCase.verifyEqual(first.Data, second.Data);
        end
        
        function pxCommutation(testCase, fs)
            % mapSpectra and pixel selection should commute
            orig = testCase.testCube; 
            
            selected = [1,1];
            first = orig.mapSpectra(fs).px(selected);
            second = orig.px(selected).mapSpectra(fs);
            
            testCase.verifyEqual(first.Data, second.Data);
        end
    end
end