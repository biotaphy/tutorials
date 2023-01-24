==============================
Tutorial 10: Create Visualizations for Outputs
==============================

Most matrices used for input or output to Biotaphy tools with sites along the 0 axis
(rows) and species data or statistics along the 1 axis (columns).  Axis headers for
the 0 axis contain the x and y coordinates for the centroid of each grid cell.
The 1 axis contains a species name or statistic for each column.

PAMs are created in Tutorial 8 from a set of species distribution layers, encoding
presence or absence values according to a set of defined rules.  The layers are saved
into a matrix file called a Presence Absence Matrix (PAM).  Each column contains data
for a single species. To examine the results of encoding you can create a multi-band
raster image of up to 256 bands.  PAMs can be rasterized before or after "wrangling".
In particular, rasterizing after applying the PurgeEmptySlicesWrangler may be
significantly smaller, as the number of species may be less (creating fewer bands) and
the geospatial extent may be reduced.

Site statistics created in Tutorials 9 and 10 are saved into one or more matrix files.
Each column contains a different statistic.

The PAM and site statistics can be written to a raster or vector file and displayed
as a map in a GIS or other map application.

--------------------
Introduction
--------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

--------------------------------
Convert a PAM to a Geotiff
--------------------------------

After encoding a set of species distribution layers into a matrix, you may want to
visually examine the results, by converting the PAM into a multi-band Geotiff file.


Input: Script parameter file
******************************************

A "wrangled" PAM, with missing rows and columns can also be turned into a raster.  The
raster may have a smaller extent than the original if sites along the boundaries have
been removed, but any sites within the smaller extent of the input PAM will be filled
in with zeros.  The wrangled PAM may be a significantly smaller file size, but will have
the same non-zero content as an original PAM.

A JSON parameter file is required for this command.  For comparison, we will wrangle
both an original PAM and the same PAM with empty rows and columns removed.
The tutorial parameter files are `convert_lmm_to_raster.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/convert_lmm_to_raster.json>`_
and  `convert_lmm_to_raster_compressed.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/convert_lmm_to_raster_compressed.json>`_.


These are the required and optional parameters:

* Required:

  * **in_lmm_filename**: The relative or absolute path for the input matrix.
  * **out_raster_filename**: The relative or absolute path for the output geotiff.

* Optional
  * **column**: Optional list of columns to rasterize.  If this parameter is left out,
    every column in the matrix (up to the limit of 256) will be in a separate band.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary

Run convert_lmm_to_raster command
******************************************

Initiate the processes with the 2 following commands:

For Linux/Mac systems:

.. code-block::

      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster.json
      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster_compressed.json
      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster_stats.json
      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster_compressed_stats.json

For Windows systems:

.. code-block::

   ./run_tutorial.bat  convert_lmm_to_raster  data/config/convert_lmm_to_raster.json
   ./run_tutorial.bat  convert_lmm_to_raster  data/config/convert_lmm_to_raster_compressed.json


Output
******************************************

Outputs are configured in the script parameter file, and may include:

1. If "report_filename" is specified in the script parameter file, a summary of the
   grid will be written to this file, like `convert_lmm_to_raster.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster.rpt>`_.
   The corresponding report for the compressed PAM clearly shows the size reduction,
   and is in  `convert_lmm_to_raster_compressed.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster_compressed.rpt>`_.
2. If "log_filename" is specified in the script parameter file, that will be created,
   like , like `convert_lmm_to_raster.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.
4. Two geotiff format raster files, each with multiple bands, one for each of the
   species, are heuchera_rfolk_1deg_global.tiff and
   heuchera_rfolk_1deg_global_noempties.tiff in the `easy_bake directory
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/>`_ .  These can be
   displayed in any mapping application.  Both the report file and metadata attached
   to the geotiff files will list the bands and the species contained within them.


--------------------------------
Convert a site statistics matrix to a Geotiff
--------------------------------

Statistics outputs are saved as matrices, and contain one or more calculations.  Some
of the statistics matrices contain site statistics, with a each statistic column
containing a value for every site.  Matrix outputs with geospatial (site) data
include:
    * covariance_stats
    * site_matrix_stats
    * site_tree_stats
    * site_tree_distance_matrix_stats
    * site_pam_dist_mtx_stats

Input: Script parameter file
******************************************

Statistics from a "wrangled" PAM, with missing rows and columns, will also have missing
sites.  As with converting a PAM, the output raster may have a smaller extent if
sites along the boundaries have been removed, but any sites within the smaller extent
of the input PAM will be filled
in with zeros.  The wrangled PAM may be a significantly smaller file size, but will have
the same non-zero content as an original PAM.

A JSON parameter file is required for this command.  For comparison, we will wrangle
both an original site-statistics matrix and site-statistics computed on a PAM with
empty rows and columns removed.  The tutorial parameter files are
`convert_lmm_to_raster_stats.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/convert_lmm_to_raster_stats.json>`_
and  `convert_lmm_to_raster_compressed.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/convert_lmm_to_raster_compressed_stats.json>`_.


The required and optional parameters are the same as when rasterizing a PAM:

* Required:

  * **in_lmm_filename**: The relative or absolute path for the input matrix.
  * **out_raster_filename**: The relative or absolute path for the output geotiff.

* Optional
  * **column**: Optional list of columns to rasterize.  If this parameter is left out,
    every column in the matrix (up to the limit of 256) will be in a separate band.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary

Run convert_lmm_to_raster command
******************************************

Initiate the processes with the 2 following commands:

For Linux/Mac systems:

.. code-block::

      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster.json
      ./run_tutorial.sh convert_lmm_to_raster data/config/convert_lmm_to_raster_compressed.json

For Windows systems:

.. code-block::

   ./run_tutorial.bat  convert_lmm_to_raster  data/config/convert_lmm_to_raster_stats.json
   ./run_tutorial.bat  convert_lmm_to_raster  data/config/convert_lmm_to_raster_compressed_stats.json


Output
******************************************

Outputs are configured in the script parameter file, and may include:

1. If "report_filename" is specified in the script parameter file, a summary of the
   grid will be written to this file, like `convert_lmm_to_raster.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster.rpt>`_.
   The corresponding report for the compressed PAM clearly shows the size reduction,
   and is in  `convert_lmm_to_raster_compressed.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster_compressed.rpt>`_.
2. If "log_filename" is specified in the script parameter file, that will be created,
   like , like `convert_lmm_to_raster.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/convert_lmm_to_raster.log>`_.
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.
4. Two geotiff format raster files, each with multiple bands, one for each of the
   species, are heuchera_rfolk_1deg_global.tiff and
   heuchera_rfolk_1deg_global_noempties.tiff in the `easy_bake directory
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/>`_ .  These can be
   displayed in any mapping application.  Both the report file and metadata attached
   to the geotiff files will list the bands and the species contained within them.


--------------------------------
Convert a species statistics matrix to a CSV
--------------------------------
