# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.9.0] - 2017-10-30
### Added
- This CHANGELOG file
- Tons of documentation and comments
- Example gallery
- Ton of test cases and a script for running the suite
- Many input parameter checks
- Parameter for mapBands to allow multidimensional return values
- Cropping can be now done also with a single parameter
- `slice()` method for opening `im_cube_slicer`
- `rgb()` method can now calculate a RGB for VIS wavelengths

### Changed
- byCols/unCols renamed to toList/fromList respectively
- `im()` uses Colorbrewer colormaps if present
- Visualizations now show some more metadata by default
- Test directories renamed to avoid name conflicts

### Fixed
- `hist()` should now work for earlier MATLAB versions in all cases

### Removed
- Misleading "Normalized" property
- `show()` method for autoselecting visualizations

[Unreleased]: https://github.com/maaleske/hsicube/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/maaleske/hsicube/compare/v0.8.0...v0.9.0
