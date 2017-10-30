# Description of the house example file

Hyperspectral image of a house and trees during fall, taken on 29.10.2017.
Imaged using a VTT prototype Fabry-Perot full frame spectral imager and a Canon
100-400 4-5.6 L lens at maximum zoom and aperture, with an exposure time of 
100ms per band. A dark reference frame was taken separately using the lens cap and substracted automatically by the camera software.

## Data

Original radiance data (in W sr^-1 m^-2 nm^-1) was calculated by the camera
software provided by VTT, with an image size of 1200 x 1920 pixels and 133 
bands corresponding to wavelengths between 456 to 840 nanometers.

This smaller example file was constructed with the following steps:

 - The last 5 bands (long wav)were dropped due to excessive noise
 - Each band was rescaled to 120 by 192 pixels (one tenth) using MATLAB imresize
 - The data was converted to 16-bit integer format by scaling the values to
   between 0 and 1, and multiplying by 65535 before casting to uint16.
   Original maximum was 0.001190876864732 W sr^-1 m^-2 nm^−1

## Authors

2017 Matti A. Eskelinen and Leevi Annala,
Faculty of Information Technology, University of Jyväskylä, Finland

## License

Creative Commons Zero (CC0)
https://creativecommons.org/publicdomain/zero/1.0/
