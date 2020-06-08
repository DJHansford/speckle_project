# speckle_analysis
MATLAB functions used to analyse speckle data

## checkparam
`checkparam`  
Script that updates your older param struct to the latest version. This should be used if you get an error when using another one of my scipts such as 'param.v.range doesn't exist'. param struct must be open in workspace. Updated param struct saved to current locaiton.

## createparam
`createparam`  
Create a param.mat file for old set of data that only has the Excel 'Data' sheet. Current folder must be where the excel data file is. Will save a param struct to the same folder that other functions I've written will be able to use.

## find_centre_of_speckle_spot
`find_centre_of_speckle_spot`  
This is a legacy script written during my DPhil.

Point at a directory which has a set of images taken under the same conditions. The name of the folder will be the title on the graph. The code finds the laser spot by matching it to a gaussian curve in the x and y dimension. The FWHM of the x gaussian is used to measure the size of the spot. It then tests each image with a range of searchboxes from 0 to 2 times the FWHM in size . It then compares that range of C values across all images and plots the average C values and the range of C values. (See Section 3.5 of Thesis)

## joinparam
`joinparam`  
Use this to combine to data sets for the same cell that have the same voltage range and consecutive frequency ranges. The param files must be named param1 (low frequencies) and param2 (high frequencies). Current folder must contain param1.m and param2.m.

## norm_speckle_images
`norm_speckle_images`  
Point MATLAB to a folder with speckle JPG images (and no other JPGs) and this will normalise them to the following criteria before saving them:  
- Intensity as high as possible for all images without over-exposing
- Mean intensity same for all images for direct comparison
- No change in Speckle Contrast values

## param_summary
`param_summary` 
Summarises param.mat data for excel files (just by outputting to console. Better to use peak_performance_table if comparing data for a range of experiments as the table can be used for plots etc

QUICK or PEAK:  
Outputs the following data in a space separated line:  
Date | Test type | Voltage range | Frequency Range | NDF | Peak V | Peak F | Min Speckle Contrast (SC) | Trans (%) at peak

STEADY STATE:  
Outputs the following data in a space separated line:  
Date | Test Type | Time (mins) | Voltage | Frequency | NDF | Average SC | SC Range | Speckle Reduction (%) | Transmission (%)

The try sections deal with old versions of param.mat and the lack of information these can suffer from. The user must input some of this missing information.
