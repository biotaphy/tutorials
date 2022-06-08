# Webinar 3: Split and merge occurrence data by species

**Webinar 3**, [Big Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.eax09dyp58l1)
(Module 2, Big-Data approaches).

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

## Data Preparation

### Input: occurrence records

The split_occurrence_data tool accepts either a Darwin Core Archive (DwCA) file or a
CSV file containing records for one or more taxa.  More information is in the
**Occurrence Data** section of [data_wrangle_occurrence](data_wrangle_occurrence.md).

### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of [data_wrangle_occurrence](data_wrangle_occurrence.md).  In this example, we will
split occurrence data, but not perform any other wrangling on it, so our [wrangler
configuration file](../data/config/wrangle_nothing.json) contains an empty list.

### Input: Script parameter file

A JSON parameter file is required for this command.  The tutorial parameter file
is [split_occurrence_data_dwca.json](../../data/config/split_occurrence_data_dwca.json).
These are the required and optional parameters:

Required:

* **out_dir**: Directory where the output data should be written.  If the directory
  does not exist, it will be created

Optional:

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

## Run tutorial with DwCA data

Initiate the split_occurrence_data process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_dwca.json
```

for windows systems

```cmd
run_tutorial.bat split_occurrence_data data\config\split_occurrence_data_dwca.json
```

## Output

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

## Run tutorial with CSV data

Initiate the split_occurrence_data process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_csv.json
```

for windows systems

```cmd
run_tutorial.bat split_occurrence_data data\config\split_occurrence_data_csv.json
```

## Run tutorial with CSV data, resolving names

Initiate the split_occurrence_data process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh split_occurrence_data data/config/split_wrangle_occurrence_data_csv.json
```

for windows systems

```cmd
run_tutorial.bat split_occurrence_data data\config\split_wrangle_occurrence_data_csv.json
```
