# screens
This folder contains two screen types used in the simulation work done in my DPhil. Screens are modelled as an array of phase changes that will be imparted onto incident light fields.

## mirror
`mirror`  
This is simply an array of zeros as a mirror should provide a perfect reflection. (Screen 6 in Table 7.1 of thesis)

## paper
`paper`  
Each subsequent number in this array is a uniformly distributed random number of the range +-pi/16 away from the previous number. This is a reasonable approximation of a paper screen for this simulation. (Screen 5 in Table 7.1 of thesis)
