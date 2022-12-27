==============================
Tutorial 10: Create Visualizations for Outputs
==============================

Site statistics created in Webinars 8 and 9 are saved into one or more matrix files with
sites along the 0 axis (rows).  Axis headers for the 0 axis contain the x and y
coordinates for the centroid of each grid cell.  The 1 axis contains a different
statistic in every column.

These

        "covariance_stats", "site_matrix_stats", "site_tree_stats",
        "site_tree_distance_matrix_stats", "site_pam_dist_mtx_stats"]


--------------------
Introduction
--------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.


--------------------------------
Rasterize a matrix containing site statistics
--------------------------------

Input: Script parameter file
******************************************

A JSON parameter file is required for this command.  The tutorial parameter file
is `rasterize_site_stats.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/build_grid_1deg_global.json>`_.
These are the required and optional parameters:

* Required:

  * **matrix_filename**: The relative or absolute path for the input matrix.
  * **raster_filename**: The relative or absolute path for the output geotiff.

* Optional
  * **statistic**: Optional single statistic to rasterize.  If none is provided, each
    statistic in the matrix will be in a separate band.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary

Run build_grid command
******************************************

Initiate the process with the following:

For Linux/Mac systems:

.. code-block::

      ./run_tutorial.sh rasterize_site_stats data/config/rasterize_site_stats.json

For Windows systems:

.. code-block::

   ./run_tutorial.bat  rasterize_site_stats  data/config/rasterize_site_stats.json


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
4. A geotiff format raster file with one or more bands, one for each statistic desired., such as the site_stats.lmm file in the
   `input directory
   <https://github.com/biotaphy/tutorials/blob/main/data/input/>`_ .
