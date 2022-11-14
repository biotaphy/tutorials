==============================
Webinar 9: Integrating Phylogenies with Species and Biogeographic Data
==============================

Analyze the PAM matrix with a tree containing the same species to determine the
phylogenetic diversity of a region.

--------------------
Introduction
--------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

--------------------
Step 1: Cleanup the matrix
--------------------

Subset the matrix to the tree species, so that statistics can be built on the
intersection of species between the phylogentic tree and the matrix.  We will trim the
matrix of all species that do not occur in the tree. We will also remove any empty
(all zeros) rows and columns.

Input: Wrangler configuration file
******************************************

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in `data_wrangle_matrix <data_wrangle_matrix>`_

We will use the wrangler configuration file `matrix_wranglers.json
<https://github.com/biotaphy/tutorials/blob/main/data/wranglers/matrix_wrangle.json>`_.
We will match our matrix to a phylogenetic tree, using the **MatchTreeMatrixWrangler**.
This requires an input tree, `heuchera.nex
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera.nex>`_.  We will
also remove any empty slices, rows or columns that are all zeros, using the
**PurgeEmptySlicesWrangler**.

**Note**: It is important when matching species between a matrix and a tree, that the
species names match when possible.  The example PAM was created from re-named species
layers (using spaces instead of underscores between the genus and species) so they
will match the tree.

Input: PAM matrix
******************************************

Use a pre-created PAM, similar to that created in `Webinar 8 <w8_build_pam>`_.
An example PAM is available in
`heuchera_pam_rn.lmm
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera_pam_rn.lmm>`_.

Input: Script parameter file
******************************************

A JSON parameter file is required for this command, and pulls together all of the input,
and output files, and any additional configuration.  The script parameter file
for this exercise is `wrangle_matrix.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/wrangle_matrix.json>`_.
These are the required and optional parameters:

* Required:

  * **in_matrix_filename**: input filename containing a PAM matrix.
  * **out_matrix_filename**: output filename for the updated matrix.
  * **wrangler_configuration_file**: matrix wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration
    contains two wranglers, the MatchTreeMatrixWrangler and the
    PurgeEmptySlicesWrangler, and is in
    `matrix_wranglers.json
    <https://github.com/biotaphy/tutorials/blob/main/data/wranglers/matrix_wrangle.json>`_

* Optional

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary

Run tutorial
******************************************

Initiate the process with the following:

For Linux/Mac systems:

.. code-block::
      ./run_tutorial.sh  wrangle_matrix  data/config/wrangle_matrix.json


For Windows systems:

.. code-block::

   ./run_tutorial.bat  wrangle_matrix  data/config/wrangle_matrix.json

Output
******************************************

This process outputs a file containing the modified matrix and any optional logfiles 
and reports specified in the Script parameter file. 

--------------------------------
Step 2: Calculate stats with the updated PAM and associated Tree
--------------------------------

We have our grid and our PAM from Webinar 9 has been built, so we re-calculate
biogeographic statistics on that PAM including phylogenetic diversity statistics
which employ the matching tree data.

Input: trimmed PAM matrix
******************************************

Use the PAM wrangled in the previous step.  The  PAM is available in
`heuchera_pam_rn_wrangled.lmm
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera_pam_rn_wrangled.lmm>`_.

Input: Script parameter file
******************************************

An example JSON file for running the calculate_pam_stats command is at
`calculate_pam_stats_pd.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/calculate_pam_stats_pd.json>`_.
These are the required and optional parameters:

* Required:

  * **pam_filename**: The full filename to the input PAM file.

* Optional

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary
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

1. A "report_filename" named in the script parameter file.
2. A "log_filename" named in the script parameter file.
3. A "log_console" named in the script parameter file, logs will be written to the
    command prompt during execution.
4. One or more "covariance_matrix" files.  Each covariance statistic produces a matrix
   and it is written to the covariance_matrix filename, where the statistic name is 
   appended to the end of the base file name.
5. A "diversity_matrix" containing different diversity statistics.
6. A "site_stats_matrix" containing site statistics.
7. A "species_stats_matrix" containing species statistics.
