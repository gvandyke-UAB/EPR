# EPR
Dr. Zvanut: Research Codebase

The folder CoordinateTool houses the visualization tool for crystal axes. It has two files, crystalAxes.m and CrystalAxesEulerAngles.m.  The former contains the code that manages the crystalAxes object, while the latter is the one you run to use the tool.

The folder CustomFunctions is just a place to dump helpful functions for use in any script. Right now it has functions that output csv-style .txt files from angle and resfields data, combine two csv-style .txt files horizontally, and normalize data.

The folder Data is for data! Currently just holds an excel sheet from Suman Bhandari's Fe data.

The folder DStrain Investigation holds spectrum, roadmap, roadmap with intensities, and stackplot scripts that Garrett Van Dyke used to look into how DStrain could be adjusted to fit experimental data.

The folder Examples has a few examples! Although, the template folder is probably a better place to copy/paste code from since it's more updated.

The SimpleTestCases folder has levelsPlot and diagonalization scripts from spin-1/2 to spin-5/2. Used as a test bed to probe the issue of our in-house spin-5/2 script returning eigenvectors that didn't match EasySpin's when B_0 = 0. No conclusion there, but ultimately not important.

The folder Templates houses template scripts for spectra, roadmaps, roadmaps with intensities, and stackplots. Comments about the Euler angles apply to gallium oxide crystals, which is noted at the top of each script. Each template is ready for quick adjustment, with the plotting labels assigned at the top so minimal interaction is required.

RoadmapTemplate.m generates text files that are ready to plot in Origin.

When you import them (Ctrl + K) into Origin, make sure to select "Show Options Dialog" in the file explorer that pops up.
In "Import Options" go to "Columns" and change the "Column Designations" dropdown box to [XY]. 
