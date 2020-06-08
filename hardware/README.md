# hardware
MATLAB code that works with our lab hardware. (Currently the Signal Generator and UV-Vis Spectrometer)

## autoswitch
`autoswitch(delay, time, field, freq)`  
AUTOSWITCH(delay, time, field, freq)  
delay: time between switching device on and off (seconds)  
time: total time to run demo (seconds)  
field: (optional) field strength (V/µm)  
freq: (optional) square-wave frequency (Hz)  

Connects to a Tektronix AFG3022 Signal Generator to apply the field required to demonstrate the LC speckle reducing device. If no field and frequency are provided it defaults to the conditions required for the cell DJH-151118-01 190329-1 at 55°C. It switches this field on and off every 'delay' seconds for a total of 'time' seconds.

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

## siggen  
This is a CLASS with a range of methods:  
`siggen(deviceid)`  
Construct a siggen instance, providing the device ID if necessary. If none is provided the default value 'USB::0x0699::0x0341::C020167::INSTR' is used. (This was my Signal Generator)  
`setup(obj,flags)`  
Set starting properties from the following input flags. Simply include the flag of all states you wish your generator to start with:  
i: infinite impedence  
q: square wave  
v: voltage concurrent  
f: frequency concurrent  
p: 180° phase change between sources  
`setv1(obj,v1set)`  
SETV1 sets source 1 voltage to v1set  
`setf1(obj,f1set)`  
SETF1 sets source 1 frequency to f1set  
`on(obj)`  
ON switches both sources on  
`off(obj)`  
OFF switches both sources off  
`close(obj)`  
CLOSE switches off the generator and closes the connection. This must be done if you wish to establish a new connection in the future.  

Connects to Tektronix AFG 3022. This could be adapted to control similar Tektronix generators. User needs to install National Instruments drivers first. (https://www.ni.com/en-gb/support/downloads/drivers/download.ni-visa.html#329456).  
This class is used by autoswitch and was intended to be integrated into the speckle measurement code but I ran out of time.

Example of use:  
`a = siggen('USB::0x0699::0x0341::C020167::INSTR');` - make 'a' - a connection to the siggen with device ID given  
`a.setup('iqvfp');` - set all initial starting properties (see above)  
`a.setv1(16.3);` - Set voltage source 1 to 16.3V  
`a.setf1(180);` - Set frequency 1 to 180 Hz  
`a.on` - switch both sources on
