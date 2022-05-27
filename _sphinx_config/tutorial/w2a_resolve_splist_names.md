# Resolve names in a list

**Webinar #2** 
[Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Create an updated/accepted species list and name-map (original_name --> accepted_name). 

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all 
tutorials work.

## Data preparation

### Input data

Use an existing or prepare a new species list, a text file with one name per line.  This 
file is specified in the Configuration file described in the next section.

1) The tutorial example species list is [heuchera.txt](../../data/input/heuchera.txt).
2) Some resources:

   1) [World Flora Online, WFO](http://www.worldfloraonline.org/)
   2) Query GBIF, i.e. 
      [heuchera query](https://www.gbif.org/species/search?q=heuchera&rank=SPECIES&qField=SCIENTIFIC)

### Tool Configuration File

A JSON tool configuration file is required for this command.  The tutorial example tool
configuration is [resolve_list_names.json](../../data/config/resolve_list_names.json). 
These are the required and optional parameters: 

   * Required:

     * **in_species_list_filename**: Input filename containing species list.  The 
       tutorial example species list is [heuchera.txt](../../data/input/heuchera.txt). 
     * **wrangler_configuration_file**: species list wrangler configuration file,
       described in the next section.  The tutorial example wrangler configuration    
       contains one wrangler, the AcceptedNameSpeciesListWrangler, and is in 
       [wrangle_list_names.json](../../data/config/wrangle_list_names.json)
     * **out_species_list_filename**: output filename for resolved species list.
   
   * Optional 

     * **log_filename**: Output filename to write logging data
     * **log_console**: 'true' to write log to console
     * **report_filename**: output filename with data modifications made by wranglers

### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more 
wranglers - each performs a different operation, and each has its own parameters.  
More information on file format, available wrangler types, and the required and/or 
optional parameters for each are [here](species_list_wrangler.md).

## Run tutorial

Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_species_list  data/config/resolve_list_names.json
```

for windows:

```cmd
run_tutorial.bat  wrangle_species_list  data\config\resolve_list_names.json
```

## Output

This process outputs a text file containing the modified species list, one name per 
line.  Current available taxonomic services include only GBIF at this time.