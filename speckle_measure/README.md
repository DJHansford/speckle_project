# speckle_measure
MATLAB functions used to measure speckle contrast in the lab

## vfsweep
`vfsweep`  
This is the script you call to run the program. There are no arguments required. Only edit the camera parameters in this script (most likely the exposure `src.Exposure`). All other parameters must be set either manually in the code (set_parameters.m) or in the UI. This calls set_parameters (to set the parameters) and make_figure (to make the UI figure). It also controls the basic UI behaviour once the figure is open but the scan hasn't been started, and has some legacy code for finding the centre of the laser spot and selecting a suitable ROI for speckle measurement (autofindcentre). Now that the set-up includes a beam homogeniser this is no longer necessary so it is commented out and replaced with selecting a 400x400 pixel square in the centre of the image.

Before starting this, make sure you point the current folder to the location of the cell you're using. eg: `...\Speckle Reduction\BL006 (MDA) R5011\4.5% DJH-151118-02\181116-1 20µm LOT 002`

## set_parameters
`set_parameters`  
This is called by vfsweep before anything else happens. It sets up all the parameters required for the test and saves them all to a global struct called 'param'. This struct is passed to and from all functions and is used to control almost every aspect of the program. Originally setting the parameters was designed to be done in the UI (the figure) but the way we use the program has evolved and the UI has not. (I intended to update it but ran out of time.) Therefore we now update all the parameters by hand by editing this code before running vfsweep.m. This is not an elegant solution but it does the job for now! All the parameters you need to consider are listed below.

Here's a rough guide on setting the parameters for each test type:  
He-Ne properties:  
Measured using the He-Ne test button - see make_figure below (btn_hene) for more details. Only check and update if you change the physical setup of the experiment.
`param.HeNesc` the speckle contrast without an LC device in the path of the He-Ne
`param.HeNerm` the sum of all intensity values in the searchbox without LC device

Setup properties:  
You must record what mixture you're using (nematic, chiral (chiral dopant) and ctab (other dopants)), the cell temperature, optics and camera details. (See comments for explanations)

User input for crucial values:  
These were all originally asked in the command window before the UI opened to ensure the user focussed on inputting them correctly. They are crucial for the correct running and saving of the data. Some have since been changed to being set directly in the code - just make sure you keep them correctly updated!  
`param.cellt` - Cell gap in µm  
`param.lot` - Cell lot (we are now tracking which delivery of cells we are using in case they vary over time)  
`param.filldate` - This distinguishes different cells filled with the same mixture  
`param.ndf` - What neutral density filter strength are you using? If using multiple, just add their values together. This is required to correct for NDF filters when calculating transmission!  
`param.scan` - What scan type are you doing? 1. Quick, 2. Peak or 3. Steady State?  
Quick: The initial test, usually 1-20V/µm in steps of 1V/µm and 20-100Hz in steps of 20 Hz  
Peak: Higher density scan around a smaller range of field values to find peak performance  
Steady State: Run the cell at one set of field conditions for a set length of times

Timing variables:  
case {1,2} (Quick and Peak tests)  
`param.fullreps` - usually set to 1, but if you want to do 10 quick tests in a row, set this to 10  
case 3 (Steady State)  
`time` - length of time in seconds  
`param.photo_time` - Save photos every x seconds (rather than saving every photo)  
`param.photo_time_n` - When to start taking photos (leave as 0 to take throughout)

Set SigGen variables:  
case {1,2} (Quick and Peak tests)  
`param.v.range` - range of field amplitudes to test (eg: 1:1:20 means 1-20 in steps of 1)  
`param.f.range` - range of frequencies to test (eg: 20:20:100 means 20-100 in steps of 20)  
case 3 (Steady State)  
`param.v.now` - field amplitude for whole test  
`param.f.now` - frequency for whole test

This also creates the connection to the Signal Generator. I wanted to update this to use my new class (siggen.m) but haven't had time to do this before leaving!

## make_figure
`make_figure`  
This function does almost all the actual work! It starts with setting up the figure (first 200 lines). Don't edit this unless you want to change how the program works!

`btn_capture`  
What happens when the Start button is pressed. This sets up the locations for saving data and images, starts the function 'run' (see below) and when its done closes down the open connection to the camera.

`run`  
Sets up the SigGen, then starts the loop of taking photos and analysing them (analyseImage) for speckle measurements and saving them to file (save_data). When the loop is finished it switches off the SigGen and finishes.

`btn_xych`  
Change the location of the square within which we measure speckle contrast. User chooses new position using mouse.

`btn_xyau`  
Automatically select the location of the laser spot. This is a legacy option we no longer use as it found the gaussian shape of the laser spot but now we have a beam homogeniser that fills the entire camera.

`btn_heneonly`  
Sets the UI input fields for doing a He-Ne only test.

`btn_hene`  
Start a test to find the current values of param.HeNesc and param.HeNerm (see above). Displays measured values in the command window when finished. (Takes less than a minute to complete.)

`btn_end`  
Switch off SigGen , save the data taken up until now and close the UI. (I don't think this works properly any more.)

`btn_clear`  
Clear the points on the updating plots of speckle contrast and transmission (underneath the camera image)

`btn_searchch`  
Change the size of the searchbox to the value typed into the UI next to this button.

## analyseimage
`analyseimage`  
Simply works out the speckle contrast in the searchbox. Don't edit this unless you want to change how the program works!

## add_data
`add_data`  
After every measurement we add the values to the param struct as well as updating the live plots in the UI. All this is done here. If we didn't save after every measurement then any crash in the program would loose all the data we'd taken. This way, even if the program crashes we don't lose any data we already took. Don't edit this unless you want to change how the program works!

## save_data
`save_data`  
When the experiment is finished we save the data as a param.m file, in an excel spreadsheet, and we plot figures that we also save as .fig and .png files. Don't edit this unless you want to change how the program works!
