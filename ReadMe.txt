How To Run: 
1. Follow the steps in order (1-5)
2. Ensure the correct Control dish is selected before running.
3. Choose graphs you want outputted
4. Run

Folder Structure:
1. Folders should be organized like so:
   MainFolder--->TreatmentID(eg. ncs100nM, time1, etc.)--->dish1 (and dish2)---->imagefolder--->images.tif
Note: The TreatmentID name is what is printed on the graphs.
AS OF NOW, THE PROGRAM ONLY ACCEPTS FILE INPUTS FROM MICROMANAGER'S 'SAVE AS INDIVIDUAL IMAGES' FORMAT. EXPECTS TO FIND FILES NAMED ACCORDINGLY (img_0000000DAPI.tif, etc).


Running In Analysis Mode:
1. While choosing data, choose folder that contains matfiles
2. Ensure the correct Control file is selected.

Outputs:
1. daExtract Images: Contains per-dish information
2. matfiles: Contains files for post-processing analysis
3. SpotPrinterVars: Contains files for running spotprinter. This displays the spots the program has picked up. 

How the program works:
1. Finds Nuclei
2. Finds spots within each nucleus
3. Calculates intensity cutoff as 'Control Mean +1*SD'. 
4. Saves this information in a '.m' file. This is in the 'matfiles' output folder.
5. Saves Nucleus and Spot segmented images in 'spotprintervars' output folder.
5. Applies the cutoffs for Area and Intensity, prints the graphs. 

Thus, 'analysis mode' loads the m-files (described in point 4.), and works very fast. To vary the cutoffs, click on the 'Standardization Mode' button on the right pane. This requires the SpotPrinterVars folder (described in point 5.) to work.  

call dhruv @ 99860-83041, or email me at dhruvr@instem.res.in if something's not working. 