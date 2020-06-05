# plotting
MATLAB plotting functions for the speckle reduction project

## savetwo
`savetwo(name)`  
name: string to use as the name of the saved figures

This will save two copies of your current MATLAB figure (.fig and .png). It also ensures the saved version is the same size as the onscreen version.

## plotcmap
`plotcmap(data,xrange,yrange,cap)`  
data: 2D speckle contrast array  
xrange: frequency range (eg param.f.range)  
yrange: field range (eg param.v.range)  
cap: Caption string if required

This will take a 2D array (such as param.results2D) of speckle contrast values from a quick or peak test and turn them into the standard colourmap. (This will not save the figures, use savetwo to save.)

## plotallcmaps
`plotallcmaps`  
Plot and save all repeat quick or peak tests (eg: 10x tests) with the caption 'Run n'. param struct must already be open in the workspace

## plotreformat
`plotreformat`  
Resize plot size, font style and weight for existing plots to use in publications. (This will not save the figures, use savetwo to save.)

## plothysteresis
`plothysteresis(num,data)`  
num:     Number of field conditions to track
data:    3D array of speckle contrast values from multiple sweeps (eg: param.results3D)

This will plot how well the cell performs over a repeat quick/peak test at the <num> best performing field conditions.

## plotcmap_trans
`plotcmap_trans`  
Use this to make a transmission colourmap. param struct must be in the workspace already. Use savetwo to save the figure.

## plotsteadystate
`plotsteadystate(param,time)`  
param:   param struct  
time:    Length of experiment in minutes for plotting (optional)

Make a steady state graph in the publication style using the param struct. Optional time input to decide how long to show on the plot.
