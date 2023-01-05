==============================
Webinar 8: Introducing Presence-Absence Matrices (PAMs)
==============================

Create a Presence-Absence Matrix (PAM) from species distribution prediction layers.
This exercise contains 3 steps.  First, we define and build a grid of our area of
interest.  This will define the size and location of grid cells used for analyzing a
set of species layers.  Second, we encode all included layers by intersecting them
with the grid, and determining whether each species is present (1) or absent (0), in
each cell.  The encoded layers are assembled into a Presence-Absence Matrix.  Finally,
we will compute statistics on the resulting PAM.

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

Input: Script parameter file
******************************************

A JSON parameter file is required for this command.  The tutorial parameter file
is `build_grid_1deg_global.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/build_grid_1deg_global.json>`_.
These are the required and optional parameters:

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
  * **report_filename**: output filename with process summary

Run build_grid command
******************************************

Initiate the process with the following:

For Linux/Mac systems:

.. code-block::

      ./run_tutorial.sh build_grid data/config/build_grid.json

For Windows systems:

.. code-block::

   ./run_tutorial.bat  build_grid  data/config/build_grid.json


Output
******************************************

Outputs are configured in the script parameter file, and may include:

1. If "report_filename" is specified in the script parameter file, a summary of the
   grid will be written to this file, like `build_grid_1deg_global.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/build_grid_1deg_global.rpt>`_.
2. If "log_filename" is specified in the script parameter file, that will be created,
   like , like `build_grid_1deg_global
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/build_grid_1deg_global.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.
4. A shapefile format grid, conforming to the arguments specified in the configuration JSON file,
   like the grid_1deg_global shapefile. It was moved from the output to the
   `input directory
   <https://github.com/biotaphy/tutorials/blob/main/data/input/>`_ because we will
   use it as an input in Step 2.

--------------------------------
Step 2: Encode species layers into grid-defined PAM
--------------------------------

Input: Layers
******************************************

Layers are specified in the Script parameter file, described fully in the next section.  
Each layer of a PAM represents the presence or absence of a taxon in the set of gridcells
used in the analysis.  Presence or absence is calculated with the min_coverage,
min_presence, and  max_presence parameters also detailed in the Script parameter file.

If you want to define different values
for computing each layer, you can create a matrix from each set of layers that
share parameters (each matrix created with a different configuration file containing
different parameters and the same grid), then aggregate the matrices in another step.

Input: Script parameter file
******************************************

An example json file for running the encode_layers tutorial is at
`encode_layers_global.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/encode_layers_global.json>`_.
These are the required and optional parameters:

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
    * (optional) label for the encoded layer in the output matrix. If no label is
      provided for a layer file, the program will first look for another file in the
      same directory with the same basename, and with the extension ".label".  If this
      Defaults to the the first line of a file in the same directory and with the same
      basename as lyr_filename and a ".label" extension, OR the basename of the layer
      file.
    * (optional) attribute. Defaults to None, using the pixel value for raster data.

  * **layer_file_pattern**: File pattern that describes one or more input files.

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with encoding summary.

Run encode_layers command
******************************************

Initiate the process with the following:

For Linux/Mac systems:

.. code-block::

      ./run_tutorial.sh encode_layers data/config/encode_layers.json

For Windows systems:

.. code-block::

      ./run_tutorial.bat encode_layers data/config/encode_layers.json

**Note**: You may get the following warning.  This indicates that there is a window with no
values, a common occurrence in most datasets, and may be safely ignored.

.. code-block::

    RuntimeWarning: Mean of empty slice
        window_mean = np.nanmean(window[np.where(window != nodata)])

Output
******************************************

Most outputs are configured in the script parameter file, and may include:

1. If "report_filename" is specified in the script parameter file, a summary of the
   encoded layers will be written to this file, like `encode_layers_1deg_global.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/encode_layers_1deg_global.rpt>`_.
2. If "log_filename" is specified in the script parameter file, that will be created,
   like , like `encode_layers_1deg_global.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/encode_layers_1deg_global.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.
4. A matrix containing one column to the arguments specified in the configuration JSON file,
   like the heuchera_rfolk_1deg_global.lmm matrix. The file is in the `input directory
   <https://github.com/biotaphy/tutorials/blob/main/data/input/>`_ because we will use
   it as input in Step 3.



--------------------------------
Step 3: Wrangle PAM to remove species with no presence
--------------------------------

Now that a grid has been built, and a PAM has been populated by intersecting species
distribution models with the grid, we will remove all species (columns) with no sites.

Input: Script parameter file
******************************************

An example JSON file for running the wrangle_matrix command is at
`wrangle_matrix_global.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/wrangle_matrix_global.json>`_.

This example wrangler will remove species with no occurrences in the sites.  We will
not remove sites without species.

These are the required and optional parameters:

* Required:

  * **in_matrix_filename**: The full filename to the input matrix.
  * **out_matrix_filename**: The full filename to the output wrangled matrix.
  * **wrangler_configuration_file**: matrix wrangler configuration file,
    described in the next section.  The tutorial example wrangler is described in the
    next section.

* Optional

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with summary

Input: Wrangler file
*******************************

An example JSON file for wrangling the matrix, in this case purging columns
of species that have no sites present, is in `matrix_wrangle.json
<https://github.com/biotaphy/tutorials/blob/main/data/wranglers/matrix_wrangle.json>`_.
In this example, we will use only the PurgeEmptySlicesWrangler, and apply it to axis 1,
the species axis.

Run wrangle_matrix command
******************************************

Initiate the wrangle_matrix process with the following:

For Linux/Mac systems

.. code-block::

      ./run_tutorial.sh wrangle_matrix data/config/wrangle_matrix_global.json

For Windows systems

.. code-block::

      ./run_tutorial.bat wrangle_matrix data/config/wrangle_matrix_global.json

Output
******************************************

The wrangle_matrix tool outputs a trimmed matrix, in this case with no empty site rows
or species columns.  Outputs may include:

1. A "report_filename" named in the script parameter file, a summary of statistics
   calculations will be written to this file, like `wrangle_matrix_global.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_matrix_global.rpt>`_.
2. A "log_filename" named in the script parameter file, that will be created, like
   `wrangle_matrix_global.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_matrix_global.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.

An example of the output matrix (heuchera_rfolk_1deg_global_trimspecies.lmm) is in the
`input directory <https://github.com/biotaphy/tutorials/blob/main/data/input>`_
because it will be used as input for computations in the Step 4.

--------------------------------
Step 4: Calculate statistics for PAM
--------------------------------

Now that the grid has been built, a PAM has been defined by intersecting species
distribution models with the grid, and the PAM has had the empty columns
trimmed, we can calculate biogeographic statistics on that PAM.

Input: Script parameter file
******************************************

An example JSON file for running the calculate_pam_stats command is at
`calculate_pam_stats.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/calculate_pam_stats.json>`_.
These are the required and optional parameters:

* Required:

  * **pam_filename**: The full filename to the input PAM file.

* Optional

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with summary
  * **covariance_matrix**: The full path and base filename for writing covariance matrices.
  * **diversity_matrix**: The full filename for writing the diversity matrix.
  * **site_stats_matrix**: The full filename for writing the site statistics matrix.
  * **species_stats_matrix**: The full filename for writing the species statistics
    matrix.
  * **tree_filename**: The full filename to an input tree in Nexus format.
  * **tree_matrix**: The full filename to an input tree encoded as a matrix.

Run calculate_pam_stats command
******************************************

Initiate the calculate_pam_stats process with the following:

For Linux/Mac systems

.. code-block::

      ./run_tutorial.sh calculate_pam_stats data/config/calculate_pam_stats.json

For Windows systems

.. code-block::

      ./run_tutorial.bat calculate_pam_stats data/config/calculate_pam_stats.json


Output
******************************************

The calculate_pam_stats tool outputs computes various statistics, depending on the
output files specified in the command configuration file.  Outputs may include:

1. A "report_filename" named in the script parameter file, a summary of statistics
   calculations will be written to this file, like `calculate_pam_stats.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/calculate_pam_stats.rpt>`_.
2. A "log_filename" named in the script parameter file, that will be created, like `calculate_pam_stats.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/calculate_pam_stats.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.

Examples of output statistics (covariance_sigma_sites.lmm, covariance_sigma_species.lmm,
diversity.lmm, species_stats.lmm) are in the `easy_bake directory
<https://github.com/biotaphy/tutorials/blob/main/data/easy_bake>`_ .

1. One or more "covariance_matrix" files.  Each covariance statistic produces a matrix
   and it is written to the covariance_matrix filename, where the statistic name is
   appended to the end of the base file name, examples are covariance_sigma_species.lmm and
   covariance_sigma_sites.lmm.
2. A "diversity_matrix" containing different diversity statistics, like diversity.lmm.
3. A "species_stats_matrix" containing species statistics, like species_stats.lmm.

An example of output site statistics (site_stats.lmm) is in the `input directory
<https://github.com/biotaphy/tutorials/blob/main/data/input>`_ because we will rasterize
it for visualization later.

4. A "site_stats_matrix" containing site statistics, like site_stats.lmm.
