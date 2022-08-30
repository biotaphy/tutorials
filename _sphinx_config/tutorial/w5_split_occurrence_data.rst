================================================================
Webinar 5: Split and merge occurrence data by species
================================================================

[Big Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.eax09dyp58l1)
(Module 2, Big-Data approaches).  Split one or more occurrence datasets by species.  
If we are splitting more than one dataset, records in different datasets with the same
species name will be combined into one file.  The tool allows multiple operations, 
defined in a configuration file, to be applied to the data at the same time, just like
in the wrangle_occurrences tool demonstrated in Webinar 3.  

The tool will group and write out occurrence records into separate CSV files based on 
a field with values to be grouped on, generally a species name. 

------------------------------------------------
Introduction
------------------------------------------------
Read [Tutorial Overview](../tutorial/w1_overview.rst) for an overview of how all
tutorials work.

------------------------------------------------
Data Preparation
------------------------------------------------
Input: occurrence records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The split_occurrence_data tool accepts one or more datasets, each must be either a 
Darwin Core Archive (DwCA) file or a CSV file containing records for one or more taxa.

More information is in the **Occurrence Data** section of 
[data_wrangle_occurrence](data_wrangle_occurrence.md).

Input: Wrangler configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of [data_wrangle_occurrence](data_wrangle_occurrence.md).  In the first example, we will
split occurrence data, but not perform any other wrangling on it, so our [wrangler
configuration file](../data/config/wrangle_nothing.json) contains an empty list.  A
second example [wrangler configuration file](../data/config/occ_wrangler_resolve.json)
resolves names with GBIF before grouping the data by name.

If more than one dataset is being processed, it is logical to apply the same wranglers 
to each.  

Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A JSON parameter file is required for this command.  Three tutorial parameter files are 
[split_occurrence_data_dwca.json](../../data/config/split_occurrence_data_dwca.json),
[split_occurrence_data_csv.json](../../data/config/split_occurrence_data_csv.json),
and 
[split_wrangle_occurrence_data.json](../../data/config/split_wrangle_occurrence_data.json).

These are the required and optional parameters:

* Required:

  * **out_dir**: Directory where the output data should be written.  If the directory
    does not exist, it will be created

* Optional:

  * **max_open_writers**: The maximum number of data writers to have open at once.
  * **key_field**: **BUGGY - IGNORE THIS FOR NOW** -
    The field name (or names) to use for filenames.  This/these must be
    encased in square brackets, i.e. `"key_field": ["scientificName"]`. If multiple
    fields are provided, the ordered fields specify the sub-directory structure used for
    organizing files.  The first field will specify the directory directly under
    out_dir, and so on.  The final field will be contain the base filename.  These
    fields should be hierarchical.  For example, if grouping records into files by
    species, with a dataset containing 2000 species, using taxonomic grouping fields
    (in order from coarser to finer groups)
    such as `"key_field": ["family", "genus", "species"]` would create a file
    with records for the Giant Panda in
    "<out_dir>/Ursidae/Ailuropoda/Ailuropoda melanoleuca.csv".
    If this parameter is not specified, it will default to the fieldname for grouping
    data.  This is a required argument for CSV files and defaults to "scientificName"
    in DwCA files.  If there are more groups/files than are allowed in a directory, the
    files will be written to subdirectories by the beginning characters in the species
    name.
  * **out_field**: The field name or names of columns to be included in output CSV files.
    If this field is left out, all fields from the first successfully processed record
    will be included in outputs.
  * **dwca**: This is an optional argument, but either this, or **csv**, must be provided.
    List of 0 or more lists, each containing 2 arguments

    * input DwCA file, and
    * occurrence data wrangler configuration file (described in the next section). The
      example split_occurrence_data wrangler configuration used for this tutorial step
      is [here](../../input/wrangle_occurrences.json)

  * **csv**: This is an optional argument, but either this, or **dwca**, must be provided.
    List of 0 or more lists, each containing 5 arguments

    * input CSV file
    * occurrence data wrangler configuration file (described in the next section).
    * fieldname for grouping data (often a taxonomic designation such as scientificName)
    * fieldname for the longitude/x coordinate
    * fieldname for the latitude/y coordinate

  * **species_list_filename**: File location to write list of species seen (after
    wrangling).
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

------------------------------------------------
Run tutorial with DwCA data
------------------------------------------------
Initiate the split_occurrence_data process with the following:
.. code-block::

      # with CSV data
      ./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_csv.json
      # with DwCA data
      ./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_dwca.json
      # with 1 DwCA and 2 CSV and resolving names with GBIF
      ./run_tutorial.sh split_occurrence_data data/config/split_wrangle_occurrence_data.json


------------------------------------------------
Output
------------------------------------------------
Most outputs are configured in the script parameter file, and may include:

1. A "report_filename" named in the script parameter file, a summary of point
   manipulations by each wrangler will be written to this file. 
2. A "log_filename" named in the script parameter file, that will be created. 
3. A "log_console" named in the script parameter file, logs will be written to the
    command prompt during execution.
4. A directory, named in the out_dir parameter, of output CSV files, one per species (or 
   other grouping field).  The basename of each CSV file will be named by the value in 
   the grouping field.  

The process also produces outputs according to the wrangler configuration file:

1. If the AcceptedNameOccurrenceWrangler is included, and there is a name-map file 
   named in out_map_filename parameter, this file will be output.  
   The name-map is a JSON file with pairs of names - 
   the original name to the accepted name according to the specified authority.  
   This name-map is suitable to use for input when resolving another dataset containing 
   a subset of the same original names.  A sample output name-map is 
   [gbif_occ.namemap](../../data/easy_bake/gbif_occ.namemap).
