==============================
Webinar 9: Integrating Phylogenies with Species and Biogeographic Data
==============================

Analyze the PAM matrix with a tree containing the same species to determine the
phylogenetic diversity of a region.

--------------------
Introduction
--------------------

Read the `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

--------------------
Step 1: Cleanup the matrix
--------------------

Subset the matrix to the tree species, so that statistics can be built on the
intersection of species between the phylogentic tree and the matrix.  We will trim the
matrix of all species that do not occur in the tree. We will also remove any empty
(all zeros) rows and columns.


Input: PAM matrix
******************************************

Use a pre-created PAM, similar to that created in `Webinar 8 <w8_build_pam>`_.
We will use the example PAM heuchera_pam_rn.lmm, available in the
`input directory
<https://github.com/biotaphy/tutorials/blob/main/data/input>`_.

Input: Wrangler configuration file
******************************************

The data wrangler configuration file names the wranglers we will use to modify the
input matrix.  This is a file containing a JSON list of wranglers - each performs a
different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in `data_wrangle_matrix <data_wrangle_matrix>`_

We will use the wrangler configuration file `matrix_wrangle.json
<https://github.com/biotaphy/tutorials/blob/main/data/wranglers/matrix_wrangle.json>`_.
We will match our matrix to a phylogenetic tree, using the **MatchTreeMatrixWrangler**.
This requires an input tree, described below.  We will also remove any empty slices,
rows/sites with no species or columns/species with no present sites, using the
**PurgeEmptySlicesWrangler**.

**Note**: It is important when matching species between a matrix and a tree, that the
species names match when possible.  The example PAM was created from re-named species
layers (using spaces instead of underscores between the genus and species) so they
will match the tree.

Input: Phylogenetic tree
******************************************

The **MatchTreeMatrixWrangler** requires a phylogenetic tree to match with the matrix.
This is named in the parameters for that wrangler in the Wrangler configuration
file.  The tree is available at  `heuchera.nex
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera.nex>`_.


Input: Script parameter file
******************************************

As with all other Biotaphy commands, a JSON parameter file is required to pull together
all of the input, and output files, and any additional parameters.  The script
parameter file for this exercise is `wrangle_matrix.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/wrangle_matrix.json>`_.
These are the required and optional parameters:

* Required:

  * **in_matrix_filename**: input filename containing a PAM matrix.
  * **out_matrix_filename**: output filename for the updated matrix.
  * **wrangler_configuration_file**: matrix wrangler configuration file,
    described in the previous section.  The tutorial example wrangler configuration
    contains two wranglers, the **MatchTreeMatrixWrangler** and the
    **PurgeEmptySlicesWrangler**.

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

The `report file <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_matrix.rpt>`_
shows a summary of the processes executed, including the species purged from the matrix because
they didn't appear in the phylogenetic tree, and the number of sites (rows) and species (columns)
removed because they were all zeros (no presence).

The resulting trimmed matrix, The resulting trimmed matrix, heuchera_pam_rn_wrangled.lmm, is in the
`input directory <https://github.com/biotaphy/tutorials/blob/main/data/input>`_ so we can use it in
the next step.

--------------------------------
Step 2: Calculate stats with the updated PAM and associated Tree
--------------------------------

Now our PAM has been pruned to contain only species in the phylogenetic tree, so we
re-calculate biogeographic statistics on it, including phylogenetic diversity statistics
which employ the matching tree data.

Input: trimmed PAM matrix
******************************************

Use the PAM wrangled in the and created as an output in the previous step.  The
wrangled PAM is available as heuchera_pam_rn_wrangled.lmm in the `input directory
<https://github.com/biotaphy/tutorials/blob/main/data/input>`_.

Input: Phylogenetic tree
******************************************

Use the same phylogenetic tree that we matched to the matrix in the previous step.
The tree is available at `heuchera.nex
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera.nex>`_.

Input: Script parameter file
******************************************

A test JSON Script parameter file for running the calculate_pam_stats command is at
`calculate_pam_stats_pd.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/calculate_pam_stats_pd.json>`_.
These are the required and optional parameters:

* Required:

  * **pam_filename**: The full filename to the input PAM file.

* Optional

  * **tree_filename**: The full filename to an input tree in Nexus format.
  * **tree_matrix**: The full filename to an input tree encoded as a matrix.
  * **covariance_matrix**: The full filename for writing the covariance matrix.
  * **diversity_matrix**: The full filename for writing the diversity matrix.
  * **site_stats_matrix**: The full filename for writing the site statistics matrix.
  * **species_stats_matrix**: The full filename for writing the species statistics 
    matrix.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with process summary

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
output files specified in the command configuration file.  Example outputs are in the
`easy_bake directory <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake>`_.
Outputs include:

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
