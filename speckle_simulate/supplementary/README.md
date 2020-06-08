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
