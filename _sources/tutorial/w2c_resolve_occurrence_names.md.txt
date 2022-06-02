# Resolve names in occurrence data

**Webinar #2**  [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Resolve the species name in each occurrence record to an "accepted" name from some
authority, either a provided name-mapping or the GBIF name resolution service.  Group
and write out occurrence records into separate CSV files with accepted names.  If the
authority is not a name-map, write out the resulting name-map
(original_name --> accepted_name).

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

## Data preparation

### Input: occurrence records

The wrangle_occurrences tool accepts either a Darwin Core Archive (DwCA) file or a
CSV file containing records for one or more taxa.  More information is in the
**Occurrence Data** section of [data_wrangle_occurrence](data_wrangle_occurrence.md).

### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in the **Occurrence Wrangler Types** section
of [data_wrangle_occurrence](data_wrangle_occurrence.md).  In this example, we will
resolve occurrence data names, but not perform any other wrangling on it, so our
[wrangler configuration file](../data/config/wrangle_nothing.json) contains only
an AcceptedNameOccurrenceWrangler.

### Input: Script parameter file

A JSON parameter file is required for this command.  The tutorial parameter file
is [resolve_occurrence_names.json](../../data/config/resolve_occurrence_names.json).
These are the required and optional parameters:

* Required:

  * **reader_filename**: The input CSV file of occurrence records.
  * **writer_filename**: A file location to write cleaned points.
  * **wrangler_configuration_file**: occurrence wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration
    contains one wrangler, the AcceptedNameOccurrenceWrangler, and is in
    [wrangle_occurrence_names.json](../../data/config/wrangle_occurrences_with_names.json)

* Optional

  * **species_key**: The field name of the input file column containing species data.
  * **x_key**: The field name of the input file column containing x/longitude coordinate.
  * **y_key**: The field name of the input file column containing y/latitude coordinate.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

## Run tutorial

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_occurrences  data/config/resolve_occurrence_names.json
```

for windows:

```cmd
run_tutorial.bat split_occurrence_data data\config\resolve_occurrence_names.json
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
