# Webinar 5: Clean Occurrence Data

**Webinar 3** [Big Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.eax09dyp58l1)
(Module 3, Big Data)

**Webinar 5** [Clean Your Dirty Data](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#)
(Module 2, Biotaphy tools)

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

## Data preparation

### Configuration File

An example json file for running the clean_occurrences tutorial is
[here](../../data/config/wrangle_occurrences.json.)  These are the required and optional
parameters:

* Required:

  * **in_filename**: An input file containing CSV occurrence data.
  * **out_filename**: A file path for output cleaned occurrence data
  * **wrangler_config_filename**: An input file containing occurrence wrangler options
    in JSON format

* Optional

  * **species_field**: The field name of the column containing species data (used for
    grouping taxa) for the out_filename.
  * **x_key**: The field name of the column containing x/longitude coordinate for the
    out_filename.
  * **y_key**: The field name of the column containing y/latitude coordinate for the
    out_filename.
  * **report_filename**: File location to write optional output report JSON.

### Input: CSV occurrence data

The split_occurrence_data tool accepts either a Darwin Core Archive (DwCA) file or a
CSV file containing records for one or more taxa.  More information is in the
**Occurrence Data** section of [data_wrangle_occurrence](data_wrangle_occurrence.md).

### Input: Wrangler configuration file

A file specifying occurrence-wranglers to apply to the CSV data, and options specific
to each.

The clean_occurrences configuration file consists of one or more Occurrence Data
Wranglers (wrangler_type), and the wrangler-specific required and possibly optional
parameters for each.  Configuration files:

* are in JSON format, a list of one dictionary per desired wrangler.
* Each dictionary must contain "wrangler_type", with the name of the wrangler types
  (listed below).
* The dictionary will also contain all required parameters and any optional
  parameters.
* Below is a list of data wrangler_types and the required and/or optional parameters
  for each.
* The [Occurrence Data Wrangler Types](data_wrangle_occurrence.md) page contains a
  list of all occurrence data wrangler_types and the required and/or optional
  parameters for each.
* Example clean_occurrences wrangler configuration:

```json
[
    {
        "wrangler_type" : "DecimalPrecisionFilter",
        "decimal_places" : 4
    },
    {
        "wrangler_type" : "UniqueLocalitiesFilter"
    },
    {
        "wrangler_type" : "MinimumPointsWrangler",
        "minimum_count" : 12
    }
]
```

## Run tutorial

Initiate the clean occurrences process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh wrangle_occurrences data/config/wrangle_occurrences.json
```

for windows systems

```cmd
./run_tutorial.bat wrangle_occurrences data\config\wrangle_occurrences.json
```

## Output

This process outputs modified occurrence data to the out_filename specified in the
script parameter file.

If "report_filename" is specified in the script parameter file, a summary of point
manipulations by each wrangler will be written to this file.

If "log_filename" is specified in the script parameter file, that will be created.

If "log_console" is specified in the script parameter file, logs will be written to the
command prompt during execution.
