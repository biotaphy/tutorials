# Resolve names in a tree

**Webinar #2** [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Create a new tree with accepted names and name-map (original_name --> accepted_name). 

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all 
tutorials work. 

## Data preparation

### Input tree data

Use an existing or create your own tree in Newick or Nexus format.  This file is 
specified in the Configuration file described in the next section.   

1) The tutorial example tree is 
[subtree-ottol-saxifragales.tre](../../data/input/subtree-ottol-saxifragales.tre).
2) Or download a tree from 
[OpenTree of Life](https://tree.opentreeoflife.org/) .  After filtering for the tree
you want, choose **Download subtree as Newick string** in the upper, rightmost panel.

### Tool Configuration File

A JSON tool configuration file is required for this command.  The tutorial example tool
configuration is [resolve_tree_names.json](../../data/config/resolve_tree_names.json). 
These are the required and optional parameters: 

* Required:

  * **tree_filename**: input tree filename.  The tutorial example tree is 
    [subtree-ottol-saxifragales.tre](../../data/input/subtree-ottol-saxifragales.tre).
  * **tree_schema**: input tree format.  The tutorial example is in "newick" format.
  * **wrangler_configuration_file**: tree wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration    
    contains one wrangler, the  AcceptedTreeWrangler, and is in 
    [wrangle_tree_names.json](../../data/config/wrangle_tree_names.json)
  * **out_tree_filename**: output tree filename
  * **out_tree_schema**: output tree format

* Optional 

  * **report_filename**: output filename with data modifications made by wranglers


### Input: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more 
wranglers - each performs a different operation, and each has its own parameters.  
More information on file format, available wrangler types, and the required and/or 
optional parameters for each are [here](tree_wrangler.md)

## Run tutorial
Initiate the process with the following:

for linux/mac systems

```zsh
./run_tutorial.sh  wrangle_tree  data/config/resolve_tree_names.json
```

for windows:

```cmd
run_tutorial.bat  wrangle_tree  data\config\resolve_tree_names.json
```

## Output

This process outputs a file containing the modified tree in the requested format, and 
any optional logfiles and reports specified in the Tool Configuration file.
Current available taxonomic services include only GBIF at this time.
