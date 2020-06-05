# spectrometer
MATLAB code that analyses the output from our spectrometer

## cell_gap
`cell_gap`  
Calculate the thicknes of your cell using interference fringes. Run this script, then select the .csv file from the UV Vis that you wish to test. Code outputs a graph of transmission against lambda (with detected peaks
shown) and plots DeltaN against lambda^-1 (from which the thickness is calculated). You are then told how many peaks there are in total and asked to select the first and last peak form which to make the calculation. Select only the peaks that reflect consecutive peaks from the transmission graph, thus forming a good straight line on DeltaN graph. Thickness measurement will be accurate when peaks are correctly chosen. Thickness is output in µm, make a note of it!
