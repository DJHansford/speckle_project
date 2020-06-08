# projector_demo
MATLAB code to automate running the projector demo

## autoswitch
`autoswitch(delay, time)`  
AUTOSWITCH(delay, time, field, freq)  
delay: time between switching device on and off (seconds)  
time: total time to run demo (seconds)  
field: (optional) field strength (V/µm)  
freq: (optional) square-wave frequency (Hz)  

Connects to a Tektronix AFG3022 Signal Generator to apply the field required to demonstrate the LC speckle reducing device. If no field and frequency are provided it defaults to the conditions required for the cell DJH-151118-01 190329-1 at 55°C. It switches this field on and off every 'delay' seconds for a total of 'time' seconds.

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
