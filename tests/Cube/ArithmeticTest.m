classdef ArithmeticTest < matlab.unittest.TestCase
    
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
        op = struct('plus',    @plus,...
                    'minus',   @minus, ...
                    'times',   @times, ...
                    'rdivide', @rdivide ...
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
           %warning('on', 'all');
        end
    end
    
    methods (Test)
        function invalidDataSize_Scalar(testCase,op)
            % Scalars do not match Cubes (unless the cube is also scalar)
            c = testCase.testCube;
            testCase.assumeNotEqual(c.Size, [1,1,1])
            testCase.verifyError(@()op(c, Cube(1)), 'Cube:OperandSizeMismatch');
        end
        
        function invalidDataSize_WidthVector(testCase,op)
            % Vectors matching cube width do not match larger Cubes
            c = testCase.testCube;
            testCase.assumeNotEqual(c.Size, [1, c.Width, 1])
            % Test vectors matching each dimension
            testCase.verifyError(@()op(c, Cube(ones(c.Width,1))), 'Cube:OperandSizeMismatch', 'Width vector accepted');
        end
        
        function invalidDataSize_HeightVector(testCase,op)
            % Vectors matching cube height do not match larger Cubes
            c = testCase.testCube;
             testCase.assumeNotEqual(c.Size, [c.Height, 1, 1])
            % Test vectors matching each dimension
            testCase.verifyError(@()op(c, Cube(ones(1,c.Height))), 'Cube:OperandSizeMismatch', 'Height vector accepted');
        end
        
        function invalidDataSize_BandVector(testCase,op)
            % Vectors matching cube band dimension do not match larger cubes
            c = testCase.testCube;
            testCase.assumeNotEqual(c.Size, [1, 1, c.nBands])
            % Test vectors matching each dimension
            testCase.verifyError(@()op(c, Cube(ones(1,1,c.nBands))), 'Cube:OperandSizeMismatch', 'Band vector accepted');
        end
        
        function invalidDataSize_WidthMismatch(testCase,op)
            % Operand width must match exactly, or we throw an error
            c = testCase.testCube;
            
            testCase.verifyError(@()op(c, Cube(ones(c.Width+1, c.Height, c.nBands))), 'Cube:OperandSizeMismatch');
            testCase.verifyError(@()op(c, Cube(ones(c.Width-1, c.Height, c.nBands))), 'Cube:OperandSizeMismatch');
        end
        
        function invalidDataSize_HeightMismatch(testCase,op)
            % Operand sizes must match exactly, or we throw an error
            c = testCase.testCube;
            
            testCase.verifyError(@()op(c, Cube(ones(c.Width, c.Height+1, c.nBands))), 'Cube:OperandSizeMismatch');
            testCase.verifyError(@()op(c, Cube(ones(c.Width, c.Height-1, c.nBands))), 'Cube:OperandSizeMismatch');
        end
        
        function invalidDataSize_BandMismatch(testCase,op)
            % Operand band size must match exactly, or we throw an error
            c = testCase.testCube;
            
            testCase.verifyError(@()op(c, Cube(ones(c.Width, c.Height, c.nBands+1))), 'Cube:OperandSizeMismatch');
            testCase.verifyError(@()op(c, Cube(ones(c.Width, c.Height, c.nBands-1))), 'Cube:OperandSizeMismatch');
        end
    end
end