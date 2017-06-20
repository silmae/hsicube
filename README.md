# hsicube

A MATLAB framework for hyperspectral cube analysis.

This package contains the following components:

  - [The main Cube class](@Cube/@Cube.m)
  - [Helper class](@ENVI/ENVI.m) for reading and writing cube data to ENVI files
Requires [ENVI file reader / writer](http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer).
  - [An InputParser subclass](@CubeArgs/@CubeArgs.m) that handles some of the argument parsing
  - [Utility functions](@Utils/Utils.m) used by the class, collected as a class
  - [Unit tests](tests/) for the above components

For usage, it is enough to add this directory to the MATLAB path.


