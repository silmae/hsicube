# hsicube

A MATLAB framework for hyperspectral cube analysis.

## Ingredients
This package contains the following components:

  - [The main Cube class](@Cube/Cube.m)
  - [Helper class](@ENVI/ENVI.m) for reading and writing cube data to ENVI files. Requires [ENVI file reader / writer](http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer).
  - [An InputParser subclass](@CubeArgs/CubeArgs.m) that handles some of the argument parsing
  - [Utility functions](@Utils/Utils.m) used by the class, collected as a class
  - [Unit tests](tests/) for the above components

## Usage
Adding this directory to your MATLAB path will bring the main classes into scope. If you wish to handle ENVI files, make sure you have [ENVI file reader / writer][envi] in path as well. For nice color maps in visualizations, you can add [Brewermap][colorbrewer] to your path and it will be used automatically.

[envi]: http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer
[colorbrewer]: https://github.com/DrosteEffect/BrewerMap

Use `doc Cube` to view the basic feature list and documentation of the main class. To get started, you can also create a Cube with some data and start playing around:

```matlab
arr = rand(32,32,256);
c = Cube(arr, 'quantity', 'Random data', 'wl', rand(1,256), 'wlu', 'arbitrary')
```

You can also see the [Cube](tests/CubeTest/) or [ENVI test files](tests/ENVITest/) for some use behaviors of the different methods.

## Citing
If you use this package for scientific work, you can cite the following conference paper:

> Software Framework For Hyperspectral Data Exploration and Processing in MATLAB
> M. A. Eskelinen
> Int. Arch. Photogramm. Remote Sens. Spatial Inf. Sci., XLII-3-W3, 47-50, https://doi.org/10.5194/isprs-archives-XLII-3-W3-47-2017, 2017

## Author

Matti A. Eskelinen, University of Jyväskylä, Finland
