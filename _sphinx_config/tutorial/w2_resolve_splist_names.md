# Webinar 2: Resolve taxonomy for a list

**Webinar #2**
[Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Create an updated/accepted species list and name-map (original_name --> accepted_name).

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

## Data preparation

### Input: species list

Use an existing or prepare a new species list, a text file with one name per line.  This
file is specified in the script parameter file described below.

1) The tutorial example species list is [heuchera.txt](../../data/input/heuchera.txt).
2) Some resources:

   1) [World Flora Online, WFO](http://www.worldfloraonline.org/)
   2) Query GBIF, i.e.
      [heuchera query](https://www.gbif.org/species/search?q=heuchera&rank=SPECIES&qField=SCIENTIFIC)

### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are [here](wrangle_species_list.md).

### Input: Script parameter file

A JSON parameter file is required for this command.  The tutorial parameter file
is [wrangle_species_list_gbif.json](../../data/config/wrangle_species_list_gbif.json).
These are the required and optional parameters:

Required:

* **in_species_list_filename**: Input filename containing species list, described
  in the section above.  The tutorial example species list is
  [heuchera.txt](../../data/input/heuchera.txt).
* **wrangler_configuration_file**: species list wrangler configuration file,
  described in the previous input section.  The tutorial example wrangler
  configuration contains one wrangler, the AcceptedNameSpeciesListWrangler, and
  is in [splist_wranglers.json](../../data/wranglers/splist_wranglers_namemap.json)
* **out_species_list_filename**: output filename for resolved species list.

Optional

* **log_filename**: Output filename to write logging data
* **log_console**: 'true' to write log to console
* **report_filename**: output filename with data modifications made by wranglers

## Demo: Run tutorial with 'gbif' service

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_species_list  data/config/wrangle_species_list_gbif.json
```

for windows:

```cmd
run_tutorial.bat  wrangle_species_list  data\config\wrangle_species_list_gbif.json
```

## Output

This process outputs a text file containing the modified species list, one name per
line, and a name-mapping from the original name to the accepted name according to the
specified authority.  This name-map is suitable to use for input when resolving another
dataset containing a subset of the same original names.

## Hands-on: Run tutorial with name-map

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_species_list  data/config/wrangle_species_list_namemap.json
```

for windows:

```cmd
run_tutorial.bat  wrangle_species_list  data\config\wrangle_species_list_namemap.json
```