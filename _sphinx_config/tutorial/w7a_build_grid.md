# Webinar 7: Build a grid to analyze a group of multi-species dataset

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

Build grid creates a geospatial grid, in vector format.  The grid is used for defining
cells (or "sites") as polygons.  These sites, or polygonal cells, can then be
intersected with other geospatial data layers, in order to generalize the values in a
layer to a single value per site.  When we intersect many data layers with the same
grid, we can create a matrix of layers by sites, and compute statistics on these values.

A grid defines the geographic extent for a term:`PAM` or other biogeographic matrix,
used for multi-species analyses. A grid is represented by term:`Polygon`s in a
term:`Vector` dataset, and written in shapefile format.

In a biogeograpic matrix,
different data layers are intersected with a geospatial grid to produce Matrices for
analyses.  Multiple two-dimensional (longitude/x and latitude/y) matrices are stacked
into a cube, then flattened back into a 2-dimensional multi-layer matrix by combining
the x and y coordinates into "sites", identified by the coordinates of the center of
the grid cell.

## Data preparation

### Input: Script parameter file

A JSON parameter file is required for this command.  The tutorial parameter file
is [build_grid.json](../../data/input/build_grid.json). These are the required
parameters:

* Required:

  * **grid_filename**: The relative or absolute path for the output grid.
  * **min_x**: The minimum value for X (longitude) coordinate of the grid.
  * **min_y**: The minimum value for Y (latitude) coordinate of the grid.
  * **max_x**: The maximum value for X (longitude) coordinate of the grid.
  * **max_y**: The maximum value for Y (latitude) coordinate of the grid.
  * **cell_size**: The size of each cell (in units indicated by EPSG).
  * **epsg**: The EPSG code for the new grid.

## Run tutorial

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh build_grid data/input/build_grid.json
```

for windows:

```cmd
run_tutorial.bat build_grid data\input\build_grid.ini
```

## Output

The build_grid tool outputs a grid in shapefile format, conforming to the arguments
specified in the configuration JSON file.
