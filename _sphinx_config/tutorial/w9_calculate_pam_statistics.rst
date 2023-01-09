==============================
Tutorial 9: Calculate PAM Statistics
==============================

The purpose of a PAM data structure is to analyze a group of species over a landscape.
We can calculate a number of statistics from the PAM, including site statistics, species
statistics, diversity, and site and species covariance.  If a phylogenetic tree is
provided, containing species that match the matrix, phylogenetic statistics will be
included in these calculations.

--------------------
Introduction
--------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

--------------------------------
Step 1: Wrangle PAM to remove species with no presence
--------------------------------

Now that a PAM has been created by intersecting species distribution models with a
grid, we will remove all species (columns) with no sites.

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

An example of the output matrix (heuchera_rfolk_1deg_global_noempties.lmm) is in the
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
