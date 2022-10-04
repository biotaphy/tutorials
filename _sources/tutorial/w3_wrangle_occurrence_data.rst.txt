============================================
Webinar 3: Wrangle occurrence data
============================================

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

Read `Tutorial Overview <../tutorial/w1_overview>`_ for an overview of how all
tutorials work.

--------------------------------
Data preparation
--------------------------------

Input: occurrence records
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The wrangle_occurrences tool accepts either a Darwin Core Archive (DwCA) file or a
CSV file containing records for one or more taxa.  More information is in the
**Occurrence Data** section of
`Specimen Occurrences: Data and Wrangling <data_wrangle_occurrence>`_.

Input: Script parameter file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A JSON parameter file is required for this command.  The tutorial parameter file is
`wrangle_occurrences_resolve.json
<https://github.com/biotaphy/tutorials/blob/main/data/config/wrangle_occurrences_resolve.json>`_.
These are the required and optional parameters:

* Required:

  * **reader_filename**: The input CSV file of occurrence records.  The tutorial input
    input file is `heuchera.csv </volumes/data/input/heuchera.csv>`_.
  * **writer_filename**: A file location to write cleaned points.
  * **wrangler_configuration_file**: occurrence wrangler configuration file,
    described in the next section.  The tutorial example wrangler is
    `occ_wrangle_resolve.json
    <https://github.com/biotaphy/tutorials/blob/main/data/wranglers/occ_wrangle_resolve.json>`_
    and is described in the next section.

* Optional

  * **species_key**: The field name of the input file column containing species data.
    The default value is `species_name`, so if the data contains any other column name
    for the field to group on, this must be specified.
  * **x_key**: The field name of the input file column containing x/longitude coordinate.
    The default value is `x`, so if the data contains any other column name
    for the x coordinate, this must be specified.
  * **y_key**: The field name of the input file column containing y/latitude coordinate.
    The default value is `y`, so if the data contains any other column name
    for the y coordinate, this must be specified.
  * **geopoint**: The field name of the input file column containing a JSON encoded
    geopoint (iDigBio data uses this field), with sub-elements containing the x and y
    keys with their coordinates.  The default value is None.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

Input: Wrangler configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The tool allows multiple operations, defined in a wrangler configuration file, to be
applied to the data at the same time.  A data wrangler configuration is a file
containing a JSON list of zero or more wranglers - each performs a different operation,
and each has its own parameters.  The file is specified in the Script parameter file
described above.

More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of `data_wrangle_occurrence <data_wrangle_occurrence>`_.

In this example, we will resolve occurrence data names with GBIF using the
AcceptedNameOccurrenceWrangler and also the DecimalPrecisionWrangler, which filters out
points without a certain number of digits past the decimal point.  Our wrangler
configuration file `occ_wrangle_resolve.json
<https://github.com/biotaphy/tutorials/blob/main/data/wranglers/occ_wrangle_resolve.json>`_
contains these parameters.


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

Initiate the process with the following:

For MacOSX or Linux systems:

.. code-block::

   ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences_resolve.json

For Windows systems:

.. code-block::

   ./run_tutorial.bat wrangle_occurrences  data/config/wrangle_occurrences_resolve.json

--------------------------------
Output
--------------------------------

This process outputs files configured in the script parameter file:

1. an output file with occurrence records named in the writer_filename, like
   `heuchera_wrangled.csv
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/heuchera_wrangled.csv>`_
   containing the occurrence records, one record per line.  Note that the species_name
   field now contains the new taxonomic name resolved for each record.  If the
   original records contain other attributes, those will be retained with their
   original values.

2. If `report_filename` is specified in the script parameter file, a summary of name
   resolutions, like
   `wrangle_occurrences.log
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_occurrences_resolve.log>`_
3. If `log_filename` is specified in the script parameter file, a report like
   `wrangle_occurrences.rpt
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/wrangle_occurrences_resolve.rpt>`_
   containing a summary of the processing.
4. If `log_console` is specified in the script parameter file, logs will be written to
   the command prompt during execution.

If the wrangler configuration file contains the AcceptedNameOccurrenceWrangler, as in
the command above, using the wrangle_occurrences_resolve.json configuration
file, the process produces one additional file as configured in that wrangler
configuration:

*  An `out_map_filename` containing a name-map from the
   AcceptedNameOccurrenceWrangler.  The name-map is a JSON file with pairs of names -
   the original name to the accepted name according to the specified authority.
   This name-map is suitable to use for input when resolving another dataset containing
   a subset of the same original names.  A sample output name-map is
   `occ_wrangle_resolve.namemap
   <https://github.com/biotaphy/tutorials/blob/main/data/easy_bake/occ_wrangle_resolve.namemap>`_.
