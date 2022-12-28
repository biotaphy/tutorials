================================================================
Webinar 5: Split and merge occurrence data by species
================================================================

Split one or more occurrence datasets by species.  This tool will split a large dataset
into separate files, grouped by species name.
If we are splitting more than one dataset, records in different datasets with the same
species name will be combined into one file.  The tool allows multiple operations, 
defined in a configuration file, to be applied to the data at the same time, just like
in the wrangle_occurrences tool demonstrated in Webinar 3.

The tool will group and write out occurrence records into separate CSV files based on 
a field with values to be grouped on, generally a species name.

The tool will add the
fields `species_name`, `x`, and `y` to every record, and leave other fields unchanged.

------------------------------------------------
Introduction
------------------------------------------------
Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

------------------------------------------------
Data Preparation
------------------------------------------------

Input: occurrence records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The split_occurrence_data tool accepts one or more datasets, each must be either a 
Darwin Core Archive (DwCA) file or a CSV file containing records for one or more taxa.
More information is in the **Occurrence Data** section of 
`Specimen Occurrences: Data and Wrangling <data_wrangle_occurrence>`_.  In our tutorial
example, we will specify a CSV file downloaded from GBIF, and a DwCA file from iDigbio,
so the output will be data merged from both data sources, and split by species name.

Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A JSON parameter file is required for this command.  The parameter file in our first
example is `split_resolve.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/split_resolve.json>`_.
This one splits both iDigBio and GBIF data, and resolves to the canonical form of
accepted names according to the GBIF taxonomy service.

The parameter file in our second example is `split_gbif.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/split_gbif.json>`_.
This one splits GBIF data, which already contains accepted names, so we can skip name
resolution.

These are the required and optional parameters:

* Required:

  * **out_dir**: Directory where the output data should be written.  If the directory
    does not exist, it will be created

* Optional:

  * **max_open_writers**: The maximum number of data writers to have open at once.
  * **out_field**: IGNORE THIS FOR NOW
  * **dwca**: This is an optional argument, but either this, or **csv**, must be
    provided.  List of 0 or more lists, each containing 2 arguments.

    * input DwCA file, and
    * occurrence data wrangler configuration file (described in the previous section).

  * **csv**: This is an optional argument, but either this, or **dwca**, must be
    provided.  List of 0 or more lists, each containing 5 arguments.

    * input CSV file
    * occurrence data wrangler configuration file (described in the next section).
    * fieldname for grouping data (often a taxonomic designation such as scientificName)
    * fieldname for the longitude/x coordinate
    * fieldname for the latitude/y coordinate
    * fieldname for the JSON-encoded geopoint (iDigBio data uses this field), with
      sub-elements containing the x and y fieldnames.

  * **species_list_filename**: File location to write list of species seen (after
    wrangling).
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers


Input: Wrangler configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of `data_wrangle_occurrence <data_wrangle_occurrence>`_.  The file is specified in the
Script parameter file described above.

An example wrangler configuration file `split_resolve.json
<https://github.com/biotaphy/tutorials/blob/main/data/wranglers/split_resolve.json>`_
resolves names with GBIF before grouping the data by name.

If more than one dataset is being processed, it is logical to apply the same wranglers
to each.

--------------------------------
Update tutorial
--------------------------------

Change directory to the top directory in your cloned tutorials repository on your local
computer, then update the repository.

.. code-block::

    astewart:~/git/tutorials$ git pull

--------------------------------
Run tutorial
--------------------------------

Initiate the split_occurrence_data process with the following commands.  The second
command uses our second example configuration, splitting GBIF data on its
acceptedScientificName field without additional name resolution.  Output example
data is from the first command.:

For MacOSX or Linux systems:
.. code-block::

  ./run_tutorial.sh split_occurrence_data data/config/split_resolve.json
  ./run_tutorial.sh split_occurrence_data data/config/split_resolve_gbif.json

For Windows systems:

.. code-block::

  ./run_tutorial.bat split_occurrence_data data/config/split_resolve.json
  ./run_tutorial.bat split_occurrence_data data/config/split_resolve_gbif.json


------------------------------------------------
Output
------------------------------------------------
Most outputs are configured in the script parameter file, and may include:

1. A "report_filename" named in the script parameter file, a summary of point
   manipulations by each wrangler will be written to this file.
   `split_resolve.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/split_resolve.rpt>`_
2. A "log_filename" named in the script parameter file, that will be created. 
   `split_resolve.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/split_resolve.log>`_
3. A "log_console" named in the script parameter file, logs will be written to the
    command prompt during execution.
4. A directory, named in the out_dir parameter, of output CSV files, one per species (or 
   other grouping field).  The basename of each CSV file will be named by the value in 
   the grouping field.  `split_resolve
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/split_resolve>`_

The process also produces outputs according to the wrangler configuration file:

1. If the AcceptedNameOccurrenceWrangler is included, and there is a name-map file 
   named in out_map_filename parameter, this file will be output.  
   The name-map is a JSON file with pairs of names - 
   the original name to the accepted name according to the specified authority.  
   This name-map is suitable to use for input when resolving another dataset containing 
   a subset of the same original names.  A sample output name-map is 
   `occ_resolve.namemap
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/occ_resolve.namemap>`_.
