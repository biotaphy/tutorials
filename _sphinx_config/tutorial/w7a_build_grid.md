# Build grid

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

Build grid creates a geospatial grid, in vector format.  The grid is used for defining
cells (or "sites") as polygons.  These sites, or polygonal cells, can then be
intersected with other geospatial data layers, in order to generalize the values in a
layer to a single value per site.  When we intersect many data layers with the same
grid, we can create a matrix of layers by sites, and compute statistics on these values.

## Data preparation

### Configuration File
An example JSON file for running the build_grid tutorial is at
../../data/input/build_grid.json. These are the 7 required parameters:

* Required:
  * **grid_filename**: The relative or absolute path for the output grid.
  * **min_x**: The minimum value for X (longitude) coordinate of the grid.
  * **min_y**: The minimum value for Y (latitude) coordinate of the grid.
  * **max_x**: The maximum value for X (longitude) coordinate of the grid.
  * **max_y**: The maximum value for Y (latitude) coordinate of the grid.
  * **cell_size**: The size of each cell (in units indicated by EPSG).
  * **epsg**: The EPSG code for the new grid.


## Run build_grid tutorial
Initiate the build_grid process with the following:

for linux/mac systems
```zsh
bash run_tutorial.sh build_grid data/input/build_grid.json
```

for windows:
```cmd
run_tutorial.bat build_grid data\input\build_grid.ini
```

## Output
The build_grid tool outputs a grid in shapefile format, conforming to the arguments specified
in the configuration INI file.
