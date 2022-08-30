============================================
Webinar 3: Wrangle occurrence data
============================================

[Clean Your Dirty Data](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.1ftkl0rid0gi)
Filter occurrence and/or modify data in a single dataset.  The tool allows multiple  
operations, defined in a configuration file, to be applied to the data at the same time. 
These operations range from filtering points out based on values in certain fields, to
filtering out all points of a certain species if the group does not match some criteria,
to modifying values in each record.

One modification that can be applied is to resolve the species name in each occurrence 
record to an "accepted" name from some authority, either a provided name-mapping or the 
GBIF name resolution service. 

--------------------------------
Introduction
--------------------------------

Read [Tutorial Overview](../tutorial/w1_overview.rst) for an overview of how all
tutorials work.

--------------------------------
Data preparation
--------------------------------

Input: occurrence records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The wrangle_occurrences tool accepts either a Darwin Core Archive (DwCA) file or a
CSV file containing records for one or more taxa.  More information is in the
**Occurrence Data** section of [data_wrangle_occurrence](data_wrangle_occurrence.md).

Input: Wrangler configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The tool allows multiple operations, defined in a wrangler configuration file, to be 
applied to the data at the same time.  A data wrangler configuration is a file 
containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.

More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of [data_wrangle_occurrence](data_wrangle_occurrence.md).  

In this example, we will
resolve occurrence data names with GBIF using the AcceptedNameOccurrenceWrangler, 
and also apply the DecimalPrecisionFilter to filter out points with a latitude or 
longitude less than 4 digits past a decimal point.  Our
[wrangler configuration file](../data/wranglers/occ_wranglers_w_resolve.json) 
contains these parameters, and the file is specified in the Script parameter file 
described next.

Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A JSON parameter file is required for this command.  The tutorial parameter file is
[wrangle_occurrences_w_resolve.json](../../data/config/wrangle_occurrences_w_resolve.json).
These are the required and optional parameters:

* Required:

  * **reader_filename**: The input CSV file of occurrence records.
  * **writer_filename**: A file location to write cleaned points.
  * **wrangler_configuration_file**: occurrence wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration
    contains one wrangler, the AcceptedNameOccurrenceWrangler, and is in
    [occ_wranglers_w_resolve.json](../../data/config/occ_wranglers_w_resolve.json)

* Optional

  * **species_key**: The field name of the input file column containing species data.
  * **x_key**: The field name of the input file column containing x/longitude coordinate.
  * **y_key**: The field name of the input file column containing y/latitude coordinate.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

--------------------------------
Run tutorial
--------------------------------

Initiate the process with the following:

.. code-block::

        # Data cleaning and name resolution
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences_w_resolve.json
        # Data cleaning only
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences.json
        # Name resolution only
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences_only_resolve.json

--------------------------------
Output
--------------------------------

This process outputs a set of CSV files, one per species, to the directory specified in
the script parameter file.  Each record is annotated with an "accepted name" as defined
in a name-map or by a taxonomic service. Records are grouped into files by matching
"accepted name".

If the "accepted name" does not come from a name-map, and a name-map filename is
specified in the wrangler configuration, that file is also an output.

If "report_filename" is specified in the script parameter file, a summary of point
manipulations by each wrangler will be written to this file.

If "log_filename" is specified in the script parameter file, that will be created.

If "log_console" is specified in the script parameter file, logs will be written to the
command prompt during execution.

Current available taxonomic services include only GBIF at this time.
