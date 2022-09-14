==============================
Webinar 8: Introducing Presence-Absence Matrices (PAMs)
==============================


--------------------
Introduction
--------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

Build grid creates a geospatial grid, in vector format.  The grid is used for defining
cells (or "sites") as polygons.  These sites, or polygonal cells, can then be
intersected with other geospatial data layers, in order to generalize the values in a
layer to a single value per site.  When we intersect many data layers with the same
grid, we can create a matrix of layers by sites, and compute statistics on these values.

A grid defines the geographic extent for a term:`PAM` or other biogeographic matrix,
used for multi-species analyses. A grid is represented by term:`Polygon`s in a
term:`Vector` dataset, and written in shapefile format.

In a biogeograpic matrix, such as a Presence-Absence Matrix, or PAM, data layers are 
intersected with a geospatial grid to produce a two-dimensional (longitude/x and 
latitude/y) Matrix for each layer.  Each 2-D matrix is converted into a 1-D matrix - 
a single column with "sites", identified by the coordinates of the center of
the grid cell.  Each row, identified by the y axis, represent a site.  In the matrix, 
this is considered the "0" axis.  Each column, identified by the x axis, represents
the species presence or absence in each site.  In the matrix, this is considered the 
"1" axis. 

--------------------------------
Step 1: Build a grid
--------------------------------

Data preparation: Script parameter file
******************************************

A JSON parameter file is required for this command.  The tutorial parameter file
is `build_grid.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/build_grid.json>`_. These are the
required and optional parameters:

* Required:

  * **grid_filename**: The relative or absolute path for the output grid.
  * **min_x**: The minimum value for X (longitude) coordinate of the grid.
  * **min_y**: The minimum value for Y (latitude) coordinate of the grid.
  * **max_x**: The maximum value for X (longitude) coordinate of the grid.
  * **max_y**: The maximum value for Y (latitude) coordinate of the grid.
  * **cell_size**: The size of each cell (in units indicated by EPSG).
  * **epsg**: The EPSG code for the new grid.

* Optional 
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

Run build_grid command
******************************************

Initiate the process with the following:

for linux/mac systems

.. code-block::
      ./run_tutorial.sh build_grid data/input/build_grid.json

Output
******************************************

The build_grid tool outputs a grid in shapefile format, conforming to the arguments
specified in the configuration JSON file.

--------------------------------
Step 2: Encode species layers
--------------------------------

Data preparation: Layers
******************************************

Layers are specified in the Script parameter file, described fully in the next section.  
Each layer of a PAM represents the presence or absence of a taxon in the analysis.  
Presence or absence is calculated with the min_coverage, min_presence, and  max_presence
parameters also detailed in the Script parameter file.  If you define different values
for computing different layers, you can create a matrix from each set of layers that
share parameters (each matrix created with the same command, called with a different  
configuration file), then aggregate the matrices in another step.  

Data preparation: Script parameter file
******************************************

An example json file for running the encode_layers tutorial is at
`encode_layers.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/encode_layers.json>`_. These are the
required and optional parameters:

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
    * (optional) label for the encoded layer in the output matrix. Defaults to the
      basename of the layer file.
    * (optional) attribute

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

Run encode_layers command
******************************************

Initiate the clean occurrences process with the following for linux/mac systems:

.. code-block::
      .\run_tutorial.sh encode_layers data/config/encode_layers.json


**Note**: You may get the following warning.  This indicates that there is a window with no
values, a common occurrence in most datasets, and may be safely ignored.

.. code-block::
    RuntimeWarning: Mean of empty slice
        window_mean = np.nanmean(window[np.where(window != nodata)])

--------------------------------
Step 3: Calculate statistics for a PAM
--------------------------------

Now that a grid has been built, and a PAM has been populated by intersecting species
distribution models with the grid, we calculate biogeographic statistics on that PAM.

Data preparation: Script parameter file
******************************************

An example JSON file for running the calculate_pam_stats command is at
`calculate_pam_stats
<https://github.com/biotaphy/tutorials/blob/main/data/config/calculate_pam_stats.json>`_.
These are the required and optional parameters:

* Required:

  * **pam_filename**: The full filename to the input PAM file.

* Optional

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers
  * **covariance_matrix**: The full filename for writing the covariance matrix.
  * **diversity_matrix**: The full filename for writing the diversity matrix.
  * **site_stats_matrix**: The full filename for writing the site statistics matrix.
  * **species_stats_matrix**: The full filename for writing the species statistics 
    matrix.
  * **tree_filename**: The full filename to an input tree in Nexus format.
  * **tree_matrix**: The full filename to an input tree encoded as a matrix.

Run calculate_pam_stats command
******************************************

Initiate the calculate_pam_stats process with the following:

for linux/mac systems

.. code-block::
      ./run_tutorial.sh calculate_pam_stats data/config/calculate_pam_stats.json


Output
******************************************

The calculate_pam_stats tool outputs computes various statistics, depending on the 
output files specified in the command configuration file.  Outputs may include:

1. A "report_filename" named in the script parameter file, a summary of point
   manipulations by each wrangler will be written to this file. 
2. A "log_filename" named in the script parameter file, that will be created. 
3. A "log_console" named in the script parameter file, logs will be written to the
    command prompt during execution.
4. One or more "covariance_matrix" files.  Each covariance statistic produces a matrix
   and it is written to the covariance_matrix filename, where the statistic name is 
   appended to the end of the base file name.
5. A "diversity_matrix" containing different diversity statistics.
6. A "site_stats_matrix" containing site statistics.
7. A "species_stats_matrix" containing species statistics.
