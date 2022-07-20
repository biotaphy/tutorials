# Webinar 7: Introducing Presence-Absence Matrices (PAMs) for Large Scale Analyses

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

## Step 1: Build a grid to analyze a group of multi-species dataset

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

### Run tutorial

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh build_grid data/input/build_grid.json
```

### Output

The build_grid tool outputs a grid in shapefile format, conforming to the arguments
specified in the configuration JSON file.

## Step 2: Encode species layers into a PAM (defined by the grid) for multi-species analysis

### Input: Layers

Layers are specified in the Script parameter file, described fully in the next section.  
Each layer of a PAM represents the presence or absence of a taxon in the analysis.  
Presence or absence is calculated with the min_coverage, min_presence, and  max_presence
parameters also detailed in the Script parameter file.  If you define different values
for computing different layers, you can create a matrix from each set of layers that
share parameters (each matrix created with the same command, called with a different  
configuration file), then aggregate the matrices in another step.  

### Input: Script parameter file

An example json file for running the encode_layers tutorial is at
../../data/config/encode_layers.json. These are the required and optional
parameters:

* Required:
  * **grid_filename**: Relative path to shapegrid to use for site geometries
  * **out_matrix_filename**: Relative path to write the encoded matrix
  * **encode_method**: The only valid option for creating a PAM is "presence_absence".  
    Other options "biogeo", "largest_class", "mean_value", are used for a different 
    types of matrices and operations.
* Optional
  * **min_coverage**: Minimum percentage of a cell that has to be covered to encode it
  * **min_presence**: Minimum value to be considered present when encoding presence
    absence
  * **max_presence**: Maximum value to be considered present
  * **layer**: list of a
    * layer filename
    * (optional) label for the encoded layer in the output matrix. Defaults to file
        basename
    * (optional) attribute

## Run encode_layers tutorial

Initiate the clean occurrences process with the following for linux/mac systems:

```zsh
bash run_tutorial.sh encode_layers data/config/encode_layers.json
```

## Note

You may get the following warning.  This indicates that there is a window with no
values, a common occurrence in most datasets, and may be safely ignored.

```commandline
RuntimeWarning: Mean of empty slice
  window_mean = np.nanmean(window[np.where(window != nodata)])
```
