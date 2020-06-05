# spectrometer
MATLAB code that analyses the output from our spectrometer

## cell_gap
`cell_gap`  
Requires Financial Toolbox, Signal Processing Toolbox in MATLAB addons  
Calculate the thickness of your cell using interference fringes. Run this script, then select the .csv file from the UV Vis that you wish to test. Code outputs a graph of transmission against lambda (with detected peaks
shown) and plots DeltaN against lambda^-1 (from which the thickness is calculated). You are then told how many peaks there are in total and asked to select the first and last peak form which to make the calculation. Select only the peaks that reflect consecutive peaks from the transmission graph, thus forming a good straight line on DeltaN graph. Thickness measurement will be accurate when peaks are correctly chosen. Thickness is output in µm, make a note of it!

## chiral_pitch
`chiral_pitch`  
Run this code on a csv file output from the UV-Vis. It knows the approx refractive indices for E7, BL006, MDA-02-2419, 5CB and the LC10-80 mixtures at room temperature to calculate the pitch from the PBG position. Select nematic type (1-7).

Select data type (1: .csv file, 2: if you have already transferred the data into a MATLAB called 'A' that has lambda values in column 1 and transmission percentage values in column 2.

Select type of pitch measurement. (1: Using entire PBG, using convolution with inverted top hat function, 2: using long band edge only (if the full PBG isn't within the visible range), 3: if you just want to observe a graph of the PBG without making calculations, 4 shows you the graph and lets you select the position of the LBE, 5 lets you select the PBG centre)

Select the csv file from the pop up box. The code will output a .fig and .png file (to the same directory as the .csv file originated) of the PBG graph with PBG centre or long band edge marked (depending on choice made above). The file name will have the pitch and PBG position included, and both will also be printed to the command window.

NOTE: If the full PBG is close to the edge of the visbile wavelength the tophat method may struggle to correctly locate the PBG. Also, this code hasn't been written to calculate the pitch using only the short band edge but would only need a small adjustment for this to be included.
