# Calculate PAM statistics

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

Now that a grid has been built, and a PAM has been populated by intersecting species
distribution models with the grid, we calculate biogeographic statistics on that PAM.

## Data preparation

### Command configuration File
An example JSON file for running the build_grid tutorial is at
../../data/input/build_grid.json. These are the 7 required parameters:

* Required:
  * **shapegrid_filename**: The relative or absolute path for the output shapegrid.
  * **min_x**: The minimum value for X (longitude) coordinate of the shapegrid.
  * **min_y**: The minimum value for Y (latitude) coordinate of the shapegrid.
  * **max_x**: The maximum value for X (longitude) coordinate of the shapegrid.
  * **max_y**: The maximum value for Y (latitude) coordinate of the shapegrid.
  * **cell_size**: The size of each cell (in units indicated by EPSG).
  * **epsg**: The EPSG code for the new shapegrid.

## Run build_shapegrid tutorial
Initiate the build_grid process with the following:

for linux/mac systems
```zsh
bash run_tutorial.sh build_grid data/config/build_grid.json
```

for windows:
```cmd
run_tutorial.bat build_grid data\input\calc_pam_stats.json
```

## Output
The build_grid tool outputs a grid in shapefile format, conforming to the arguments
specified in the command configuration file.
