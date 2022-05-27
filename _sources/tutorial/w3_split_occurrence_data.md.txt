# Resolve taxonomy in a Darwin Core Archive (DwCA)

**Webinar 3**, [Big Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.eax09dyp58l1) 
(Module 2, Big-Data approaches)

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all tutorials work. 

## Data Preparation

### Input occurrence data

The split_occurrence_data tool accepts either a Darwin Core Archive (DwCA) file or a 
CSV file containing records for one or more taxa.  

1) The tutorial example DwCA is at [occ_sax_gbif.zip](../../data/input/occ_sax_gbif.zip)
2) To download from GBIF, choose your filters in the portal 
   https://www.gbif.org/occurrence.  For example, to select occurrences where 
   genus=`Heuchera L`, 
   https://www.gbif.org/occurrence/search?taxon_key=3032645&occurrence_status=present.
   Then choose the download link at the upper right column header.
3) To download from iDigBio, instructions for querying and downloading from the 
   command prompt are at [idigbio_download.md](./idigbio_download.md). 

### Tool Configuration file


[here](occurrence_wrangler_config.md)

  * **max_open_writers**: The maximum number of data writers to have open at once.
  * **key_field**: The field name (or names) to use for filenames.  This/these must be 
    encased in square brackets, i.e. `"key_field": ["scientificName"]`. If multiple fields
    are provided, the ordered fields specify the sub-directory structure used for 
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
  * **dwca**: List of 0 or more lists, each containing 2 arguments 
    * input DwCA file, and
    * occurrence data wrangler configuration file (described in the next section). The 
      example split_occurrence_data wrangler configuration used for this tutorial step 
      is [here](../../input/wrangle_occurrences.json)
  * **csv**:  List of 0 or more lists, each containing 5 arguments 
    * input CSV file
    * occurrence data wrangler configuration file (described in the next section).
    * fieldname for grouping data (often a taxonomic designation such as scientificName)
    * fieldname for the longitude/x coordinate
    * fieldname for the latitude/y coordinate

### Occurrence Data Wranglers

An example split_occurrence_data wrangler configuration used for this tutorial step is 
[here](../../input/wrangle_occurrences.json)

The split_occurrence_data configuration file consists of one or more "wrangler_type"s, 
and= the wrangler-specific required and possibly optional parameters for each.  
Available wrangler_types with their parameters are listed at
[Occurrence Data Wrangler Types](occurrence_wrangler.md)

```json lines

```

## Run split_occurrence_data tutorial 

Initiate the clean occurrences process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data.json
```

for windows systems

```cmd
run_tutorial.bat split_occurrence_data data\config\split_occurrence_data.json
```
