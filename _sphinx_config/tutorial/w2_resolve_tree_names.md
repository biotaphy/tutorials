# Resolve names in a tree

**Webinar #2** [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Using pre-generated name-map 

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all tutorials work. 

## Data preparation

### Input: tree data

Use your own tree in Newick or Nexus format, or download from 
[OpenTree of Life](https://tree.opentreeoflife.org/) .  After filtering for the tree
you want, choose **Download subtree as Newick string** in the upper, rightmost panel.

### Configuration File

A JSON configuration file is required for this command.  These are the required and 
optional parameters: 

* Required:

  * **tree_filename**: input tree filename
  * **tree_schema**: input tree format
  * **wrangler_configuration_file**: tree data wrangler configuration file 
  * **out_tree_filename**: output tree filename
  * **out_tree_schema**: output tree format

* Optional 

  * **report_filename**: output filename with data modifications made by wranglers

An example configuration file to process a tree, using data wranglers specified in 
wrangler_conf_resolve_occurrence_names.json, writing all files to the 
/biotaphy_data/output directory.  

```json lines
{
    "report_filename": "/biotaphy_data/output/resolve_tree_names.rpt",
    "tree_filename": "/biotaphy_data/input/subtree-ottol-648890-Saxifragales.tre",
    "tree_schema": "newick",
    "wrangler_configuration_file": "/biotaphy_data/param_config/wrangler_conf_resolve_tree_names.json",
    "out_tree_filename": "/biotaphy_data/output/ottol-Saxifragales.tre",
    "out_tree_schema": "newick"
}
```

### Input: Wrangler configuration file

A file specifying 0 or more tree-wranglers to apply to the tree data, and options 
specific to each.   

The resolve_tree_names.json  configuration file consists of zero or more Tree Data 
Wranglers (wrangler_type), and the wrangler-specific required and possibly optional 
parameters for each.  Configuration files:
  * are in JSON format, a list of one dictionary per desired wrangler.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler types.
  * The dictionary will also contain all required parameters and any optional parameters.
  * A list of tree wrangler_types and the required and/or optional parameters for each
    are [here](tree_wrangler_config.md)


## Run tutorial
Initiate the process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh wrangle_tree data/param_config/resolve_tree_names.json
```

for windows:

```cmd
run_tutorial.bat wrangle_tree data\param_config\resolve_tree_names.json
```

## Output
This process outputs a file containing the modified tree in the requested format, one 
Current available taxonomic services include only GBIF at this time.