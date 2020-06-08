# supplementary
These functions support run_lc_to_camera

## cumulative_sc
`p = cumulative_sc(loop,p)`  
loop: struct used by run_lc_to_camera to store simulation parameters  
p: struct used by run_lc_to_camera to store simulation parameters

Works out the cumulative speckle contrast when you average the output intensity fields for increasing numbers of intensity fields at the camera. It plots the change in SC as the number of averaged frames increases and saves them to file.

## findfolderswith
`folders = findfolderswith(location, search_string, filetype)`  
location: folder to look in  
search_string: string to be included in the file name (use `'*''` to list all files in the directory)  
filetype: filetype to limit search to (use `'*''` to search all filetypes)

FINDFOLDERSWITH returns a list of folders in the directory 'location' that contain a file with 'search_string' in their name and are the correct 'filetpe'.

`A = FINDFOLDERSWITH('C:\Users\bras2756\Documents','test','txt')`  
Output is a list of folders that contain any file with 'test' in the name that are of type .txt

## prop_lc_to_camera
`[p, loop] = prop_lc_to_camera(p)`  
p: struct used by run_lc_to_camera to store simulation parameters  
loop: struct used by run_lc_to_camera to store simulation parameters

PROP_LC_TO_CAMERA simulates light propagation from LC device (random scattering) through lens onto scattering screen (not in focus). This is imaged by eye/CCD in focus. It is called by run_lc_to_camera.

## copynewfiles
`newcopy = copynewfiles(oldloc, newloc, search, filetype)`  
oldloc: Location (folder) to copy new files from  
newloc: Location (folder) to copy new files into  
search: text string required in filenames for them to be copied  
filetype: Filetype to be included in the search

This code looks in oldloc for any files with 'search' in their name, checks if they exist already in newloc and copies them over if they don't. It will display the number of files found and copied. It will also preserve the folder structure within oldloc in newloc and create any required new folders. ONLY WORKS WITH MATLAB 2017 AND BEYOND. (This isn't currently being used by anything in this folder.)
