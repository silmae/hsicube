classdef ENVITest < matlab.unittest.TestCase
    
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
           wls  = gallery('uniformdata', [1, nbands], 1);
           fwhms= gallery('uniformdata', [1, nbands], 2);
           % Suppress default value warnings for clearer test output
           warning('off', 'Cube:DefaultQuantity');
           testCase.testCube = Cube(data,'wl',wls,'fwhm',fwhms);
           % Turn warnings back on
           warning('on', 'all');
        end
    end
    
    methods (Test)
        function writeReadDataIdentity(testCase)
            % Writing a Cube to ENVI and reading it back should not change
            % the data.

            orig = testCase.testCube;
            tmpfile = tempname;
            
            ENVI.write(orig, tmpfile);
            new = ENVI.read([tmpfile, '.dat']);
            delete([tmpfile, '.dat']);
            delete([tmpfile, '.hdr']);
            
            testCase.verifyEqual(new.Data, orig.Data);
        end
        
        function writeReadMetaIdentity(testCase)
            % Writing a Cube to ENVI should preserve the metadata, at least 
            % up to single precision
            orig = testCase.testCube;
            tmpfile = tempname;
            
            ENVI.write(orig, tmpfile);
            new = ENVI.read([tmpfile, '.dat']);
            delete([tmpfile, '.dat']);
            delete([tmpfile, '.hdr']);
            
            testCase.verifyEqual(single(new.Wavelength), single(orig.Wavelength), 'Wavelengths changed');
            testCase.verifyEqual(single(new.FWHM), single(orig.FWHM), 'FWHMs changed');
        end
        
        function findhdrFileNotFound(testCase)
            % findhdr should throw an error if the file does not exist
            tmpfile = [tempname, '.hdr'];
            testCase.assumeEqual(exist(tmpfile, 'file'),0);
            testCase.verifyError(@()ENVI.findhdr(tmpfile),'ENVI:HeaderNotFound');
        end
    end
end