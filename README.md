# hsicube

A MATLAB framework for hyperspectral cube analysis.

## Ingredients
This package contains the following components:

  - [The main Cube class](@Cube/Cube.m)
  - [Wrapper class](@ENVI/ENVI.m) for reading and writing cube data to ENVI files. Requires [ENVI file reader / writer](http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer)
  - [An InputParser subclass](@CubeArgs/CubeArgs.m) that handles some of the argument parsing
  - [Utility functions](@Utils/Utils.m) used by the class, collected as a class
  - [Unit tests](tests/) for the above components
  - [An example gallery](examples/)

## Usage
1. Clone the repository:

   `git clone git@github.com:maaleske/hsicube.git`

2. Add this directory to your MATLAB path to bring the main classes into scope: 

   `addpath('hsicube')`

Additional functionality:
- To handle ENVI files using the included `ENVI` wrapper class, include the files from [ENVI file reader / writer][envi] in your path beforehand.
- For nice color maps in visualizations, add [Brewermap][colorbrewer] to your path and it will be used automatically.
- To use the `slice()` method, download [im_cube_slicer][slicer] and add it to path.

[envi]: http://se.mathworks.com/matlabcentral/fileexchange/27172-envi-file-reader-writer
[colorbrewer]: https://github.com/DrosteEffect/BrewerMap
[slicer]: https://se.mathworks.com/matlabcentral/fileexchange/40076-hyperspectral-image-cube-slicer

Use `doc Cube` to view the basic feature list and documentation of the main class. The [Examples](examples/) directory contains some examples (which you can view easily as HTML by running `publish('examplefile.m')` in MATLAB.

If you wish to delve deeper, most of the code should be well commented. You can also see the [Cube](tests/CubeTest/) or [ENVI test files](tests/ENVITest/) for expected behaviors of the different methods.

## Citing
If you use this package for scientific work, you can cite the following conference paper:

> Software Framework For Hyperspectral Data Exploration and Processing in MATLAB<br />
> M. A. Eskelinen<br />
> Int. Arch. Photogramm. Remote Sens. Spatial Inf. Sci., XLII-3-W3, 47-50, https://doi.org/10.5194/isprs-archives-XLII-3-W3-47-2017, 2017<br />

Or in BibTeX format:
 
> @Article{isprs-archives-XLII-3-W3-47-2017,<br />
> AUTHOR = {Eskelinen, M. A.},<br />
> TITLE = {SOFTWARE FRAMEWORK FOR HYPERSPECTRAL DATA EXPLORATION AND PROCESSING IN MATLAB},<br />
> JOURNAL = {ISPRS - International Archives of the Photogrammetry, Remote Sensing and Spatial Information Sciences},<br />
> VOLUME = {XLII-3/W3},<br />
> YEAR = {2017},<br />
> PAGES = {47--50},<br />
> URL = {https://www.int-arch-photogramm-remote-sens-spatial-inf-sci.net/XLII-3-W3/47/2017/},<br />
> DOI = {10.5194/isprs-archives-XLII-3-W3-47-2017}<br />
> }

For referring to specific versions, you can look for the corresponding version on [Zenodo](https://zenodo.org/search?q=hsicube).

## Author
2017 Matti A. Eskelinen, University of Jyväskylä, Finland
