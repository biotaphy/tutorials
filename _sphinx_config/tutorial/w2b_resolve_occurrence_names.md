# Resolve names in occurrence data

**Webinar #2**  Resolving Nomenclature: Making Appropriate Taxonomic Choices

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all tutorials work. 

## Data preparation

### Input: occurrence data

Either, 
1) a file containing tab or comma-delimited records of specimen occurrence data; or 
2) a Darwin Core Archive (DwCA) of occurrence data. 

[GBIF](https://www.gbif.org/), [iDigBio](https://www.idigbio.org/portal), 
[Atlas of Living Australia](https://www.ala.org.au/), and more, provide 
portals for querying for, and downloading either CSVs or DwCAs.

### Configuration File

A JSON configuration file is required for this command.  These are the required and 
optional parameters: 

* Required:

  * **out_dir**: The parent output directory for CSVs of occurrence records resulting 
    from splitting the data by species (or other grouping field).
  
* Optional 

  * **max_open_writers**: The maximum number of files that can be open at one time for 
    writing occurrence records.  The default value of 100 is appropriate for most 
    systems.
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
    * occurrence data wrangler configuration file
  * **csv**:  List of 0 or more lists, each containing 5 arguments 
    * input CSV file
    * occurrence data wrangler configuration file
    * fieldname for grouping data (often a taxonomic designation such as scientificName)
    * fieldname for the longitude/x coordinate
    * fieldname for the latitude/y coordinate
    
An example configuration file to process a DwCA, using data wranglers specified in 
wrangle_occnames.json, writing all files to the /biotaphy_data/output directory.  

```json lines
{
    "max_open_writers": 100,
    "key_field": "scientificName",
    "dwca":  [
        ["/biotaphy_data/input/occ_idigbio.zip",
         "/biotaphy_data/param_config/wrangle_occnames.json"
        ]
    ],
    "out_dir": "/biotaphy_data/output"

}
```

An example configuration file to process a CSV, using data wranglers specified in 
wrangler_conf_resolve_occurrence_names2.json, writing the files to the 
/biotaphy_data/output directory.  

```json lines
{
    "max_open_writers": 100,
    "key_field": ["family", "genus", "scientificName"],
    "csv":  [
        ["/biotaphy_data/input/gbif_sax_100k.csv",
         "/biotaphy_data/param_config/wrangle_occurrences.json",
         "scientificName", 
          "longitude", 
          "latitude"
        ]
    ],
    "out_dir": "/biotaphy_data/output"

}
```

### Input: Wrangler configuration file

A file specifying 0 or more occurrence-wranglers to apply to the occurrence data, and  
options specific to each.    

The resolve_occurrence_names.json  configuration file consists of one or more Occurrence 
Data Wranglers (wrangler_type), and the wrangler-specific required and possibly optional
parameters for each.  Configuration files:

  * are in JSON format, a list of one dictionary per desired wrangler.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler types.
  * The dictionary will also contain all required parameters and any optional parameters.
  * The [Occurrence Data Wrangler Types](occurrence_wrangler.md) page contains a
    list of all occurrence data wrangler_types and the required and/or optional 
    parameters for each.
  * Example resolve_occurrence_names wrangler configuration:

```json
[
    {
        "wrangler_type": "AcceptedNameOccurrenceWrangler",
        "name_resolver": "gbif"
    }
]

```


## Run tutorial
Initiate the process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh split_occurrence_data data/input/resolve_occurrence_names.json
```

for windows:

```cmd
run_tutorial.bat split_occurrence_data data\input\resolve_occurrence_names.json
```

## Output
This process outputs a set of CSV files, one per species, in which each record is 
annotated with an "accepted name" as defined in a name-map or by a taxonomic service.
Current available taxonomic services include only GBIF at this time.
