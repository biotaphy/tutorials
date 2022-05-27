# Resolve names in occurrence data

**Webinar #2**  [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Create a new tree with accepted names and name-map (original_name --> accepted_name). 

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all 
tutorials work. 

## Data preparation

### Input: occurrence data

Use an existing or prepare a new occurrence CSV file, a text file with one species 
occurrence record per line.  This file is specified in the Configuration file described 
in the next section.  The tutorial example occurrence datafile is 
[heuchera.csv](../../data/input/heuchera.csv).

### Tool Configuration File

A JSON tool configuration file is required for this command.  The tutorial example tool
configuration is 
[resolve_occurrence_names.json](../../data/config/resolve_occurrence_names.json). 
These are the required and optional parameters: 

* Required:

  * **reader_filename**: The input CSV file of occurrence records.
  * **writer_filename**: A file location to write cleaned points.
  * **wrangler_configuration_file**: occurrence wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration    
    contains one wrangler, the AcceptedNameOccurrenceWrangler, and is in 
    [wrangle_occurrence_names.json](../../data/config/wrangle_occurrence_names.json)
  
* Optional 

  * **species_key**: The field name of the input file column containing species data.
  * **x_key**: The field name of the input file column containing x/longitude coordinate.
  * **y_key**: The field name of the input file column containing y/latitude coordinate.
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

    

### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more 
wranglers - each performs a different operation, and each has its own parameters.  
More information on file format, available wrangler types, and the required and/or 
optional parameters for each are [here](occurrence_wrangler.md).

## Run tutorial
Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_occurrences  data/input/resolve_occurrence_names.json
```

for windows:

```cmd
run_tutorial.bat split_occurrence_data data\input\resolve_occurrence_names.json
```

## Output
This process outputs a set of CSV files, one per species, in which each record is 
annotated with an "accepted name" as defined in a name-map or by a taxonomic service.
Current available taxonomic services include only GBIF at this time.
