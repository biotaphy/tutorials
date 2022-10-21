==================================
Webinar 6: Species Distribution Modeling (SDM)
==================================

Create one or more Species Distribution Models using Maxent for
occurrence data with the minimum number of points defined in the configuration file or
the `Rare Species Model` algorithm for data without the required minimum number of
points.  The Rare Species Model intersects the convex hull of the points
with a raster denoting ecoregions.  For all species data using Maxent, the tool uses the
Maxent parameters indicated in the configuration file.  

-----------------------------------
Introduction
-----------------------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

-----------------------------------
Data Preparation
-----------------------------------

Input: occurrence records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The create_sdm tool accepts one or more occurrence CSV datasets, defined in two ways in  
the configuration file: either specified by a parent directory in the `points_dir` 
parameter, and/or a list of individual files in the `points_layer` parameter.  Each of 
the occurrence datasets must use the same species_key, x_key, and y_key, specified in
the configuration file. 

More information is in the **Occurrence Data** section of `data_wrangle_occurrence
<data_wrangle_occurrence#occurrence-data>`_.

Input: ecoregions file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ecoregions file is a raster file indicating broad ecoregions for the region
being modeled.


Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A JSON parameter file is required for this command.  A test tutorial parameter file is: 
`create_sdm.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/create_sdm.json>`_,

These are the required and optional parameters:

* Required:

  * **out_dir**: Parent directory where the output species directories containing output 
    data should be written.  If the directory does not exist, it will be created
  * **env_dir**: Directory containing the environmental raster files for modeling and 
    projecting species distributions.
  * **ecoregions_filename**: Raster file denoting ecologically and geographically defined 
    regions to be used for modeling rare species or as a mask for the Maxent algorithm.

* Optional:

  * **points_dir**: Parent directory containing occurrence data in CSV format.  The tool 
    will attempt to model all CSV files in this directory.  Though this parameter is 
    optional, one or both of `points_dir` and `points_layer` must be included.
  * **points_layer**: List of filenames containing occurrence data in CSV format.
    Though this parameter is optional, one or both of `points_dir` and `points_layer` must
    be included.
  * **species_key**: The field name of the column containing the taxon value in all 
    occurrence data files. If this parameter is not specified, it will default to 
    `species_name` (which is also the default value created in CSV data output from
    split_occurrence_data and wrangle_occurrences).
  * **x_key**: The field name of the column containing the x/longitude value in all 
    occurrence data files. If this parameter is not specified, it will default to 
    `x` (which is also the default value created in CSV data output from
    split_occurrence_data and wrangle_occurrences).
  * **y_key**: The field name of the column containing the y/latitude value in all 
    occurrence data files. If this parameter is not specified, it will default to 
    `y` (which is also the default value created in CSV data output from
    split_occurrence_data and wrangle_occurrences).
  * **maxent_params**: Extra options and parameters to be sent to Maxent.  A full list
    of Maxent parameters, along with the value type, and sometimes a valid range of
    values, is available in the
    `Maxent Github repository
    <https://github.com/mrmaxent/Maxent/blob/master/density/parameters.csv>`_.
  * **min_points**: Minimum number of points in an occurrence dataset for Maxent to be 
    used for modeling to.  If the data contains less than the minimum, the
    `Rare Species Modeling` algorithm will be used.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

-----------------------------------
Run tutorial
-----------------------------------

with a list and a directory containing occurrence data files.

Initiate the create_sdm process with the following:

.. code-block::
      ./run_tutorial.sh create_sdm data/config/create_sdm.json


For Windows systems:

.. code-block::

   ./run_tutorial.bat  create_sdm  data/config/create_sdm.json

-----------------------------------
Output
-----------------------------------

Most outputs are configured in the script parameter file, and may include:

1. If "report_filename" is specified in the script parameter file, a summary of point
   manipulations by each wrangler will be written to this file. 
2. If "log_filename" is specified in the script parameter file, that will be created. 
3. If "log_console" is specified in the script parameter file, logs will be written to the
   command prompt during execution.
4. A directory named in the out_dir parameter, containing a subdirectory for each 
   input occurrence data file.  Each subdirectory will be named by the value in 
   the grouping field and contain a predicted distribution raster in ASCII format.  
   Occurrence data that were modeled with Maxent will also contain Maxent outputs.
   Species outputs from the above command are in the directory `heuchera_rfolk_sdm
   <https://github.com/biotaphy/tutorials/tree/main/data/input/heuchera_rfolk_sdm>`_.
   The data are in the `input` directory instead of `easy_bake` because we will use these
   data as input to `encode_layers` which builds a Presence-Absence Matrix, described
   in `Webinar 8 <w8_build_pam>`_.
