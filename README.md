# hsicube

A MATLAB framework for hyperspectral cube analysis.

## Ingredients
This package contains the following components:

  - [The main Cube class](@Cube/@Cube.m)
  - [Helper class](@ENVI/ENVI.m) for reading and writing cube data to ENVI files
Requires [ENVI file reader / writer](http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer).
  - [An InputParser subclass](@CubeArgs/@CubeArgs.m) that handles some of the argument parsing
  - [Utility functions](@Utils/Utils.m) used by the class, collected as a class
  - [Unit tests](tests/) for the above components

## Usage
Adding this directory to your MATLAB path will bring the main classes into scope. If you wish to handle ENVI files, make sure you have the ENVI file reader / writer in path as well.

Documentation is still under construction. Try creating a Cube object and see what you can do with it:

```
arr = rand(10, 10, 100);
myfirstcube = Cube(arr);
```

You can also see the [Cube](tests/Cube/) or [ENVI tests](tests/ENVI/) for some use cases.

## Author

Matti A. Eskelinen, University of Jyväskylä, Finland
