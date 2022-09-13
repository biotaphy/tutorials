=======================================
Webinar 2: Resolving Nomenclature
=======================================

Create an updated/accepted species list and name-map (original_name --> accepted_name).

---------------------------
Introduction
---------------------------

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

---------------------------
Data preparation
---------------------------

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Input: species list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use an existing or prepare a new species list, a text file with one name per line.  This
file is specified in the script parameter file described below.

1) The tutorial example species list is `heuchera.txt
<https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera.txt>`_.
2) Some resources:

   1) `World Flora Online, WFO <http://www.worldfloraonline.org/>`_
   2) Query GBIF, i.e.
      `heuchera query <https://www.gbif.org/species/search?q=heuchera&rank=SPECIES&qField=SCIENTIFIC>`_

Input: Wrangler configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are at
`Species List: Wrangling <data_wrangle_species_list>`_.

Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A JSON parameter file is required for this command.  The tutorial parameter file
is `wrangle_species_list_gbif.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/wrangle_species_list_gbif.json>`_.
These are the required and optional parameters:

Required:

* **in_species_list_filename**: Input filename containing species list, described
  in the section above.  The tutorial example species list is
  `heuchera.txt <https://github.com/biotaphy/tutorials/blob/main/data/input/heuchera.txt>`_.
* **wrangler_configuration_file**: species list wrangler configuration file,
  described in the previous input section.  The tutorial example wrangler
  configuration contains one wrangler, the AcceptedNameSpeciesListWrangler, and 
  is in `splist_wrangle_gbif.json
  <https://github.com/biotaphy/tutorials/blob/main/data/wranglers/splist_wrangle_gbif.json>`_
* **out_species_list_filename**: output filename for resolved species list.

Optional

* **log_filename**: Output filename to write logging data
* **log_console**: 'true' to write log to console
* **report_filename**: output filename with data modifications made by wranglers

-------------------------------------------------
Hands-on: Run tutorial with 'gbif' service
-------------------------------------------------

Initiate the process with the following:

.. code-block::

       ./run_tutorial.sh wrangle_species_list data/config/wrangle_species_list_gbif.json

---------------------------
Output
---------------------------
This process outputs files configured in the script parameter file:

2. If `report_filename` is specified in the script parameter file, a summary of name
   resolutions, like
   `wrangle_species_list_gbif.log <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_species_list_gbif.log>`_
3. If `log_filename` is specified in the script parameter file, a report like
   `wrangle_species_list_gbif.rpt <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_species_list_gbif.rpt>`_
   containing a summary of the processing.
3. If `log_console` is specified in the script parameter file, logs will be written to
   the command prompt during execution.
4. an output species list named in the out_species_list_filename, like
   `heuchera_wrangled.txt <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/heuchera_wrangled.txt>`_
   containing the modified species list, one name per line.

The process produces one additional file configured in the wrangler configuration file:

*  An `out_map_filename` containing a name-map from the
   AcceptedNameSpeciesListWrangler.  The name-map is a JSON file with pairs of names -
   the original name to the accepted name according to the specified authority.  
   This name-map is suitable to use for input when resolving another dataset containing 
   a subset of the same original names.  A sample output name-map is 
   `splist_wrangle_gbif.namemap <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/splist_wrangle_gbif.namemap>`_.
