# Webinar 8: Phylogenetic diversity: Integrating Phylogenies with Species and Biogeographic Data

**Webinar #8**  [Phylogenetic diversity: Integrating Phylogenies with Species and 
Biogeographic Data](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.z9bjp5mgfgld)
Analyze the PAM matrix with a tree containing the same species to determine the 
phylogenetic diversity of a region.

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all
tutorials work.

## Step 1: Subset the matrix to the tree species (wrangle_matrix)

### Data preparation: Script parameter file

A JSON parameter file is required for this command.  The tutorial parameter file
is [resolve_tree_names.json](../../data/config/resolve_tree_names.json). These are the
required and optional parameters:

* Required:
  * **in_matrix_filename**: input filename containing a PAM matrix. 
  * **out_matrix_filename**: output filename for the updated matrix.
  * **wrangler_configuration_file**: matrix wrangler configuration file,
    described in the next section.  The tutorial example wrangler configuration
    contains two wranglers, the MatchTreeMatrixWrangler and the 
    PurgeEmptySlicesWrangler, and is in
    [matrix_wranglers.json](../../data/wranglers/matrix_wranglers.json)

* Optional
  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

### Data preparation: Input matrix

Use a PAM created in [Tutorial 7](./w7_build_pam.md).  An example PAM is available in 
[pam.lmm](../../data/input/pam.lmm).

### Data preparation: Wrangler configuration file

A data wrangler configuration is a file containing a JSON list of zero or more
wranglers - each performs a different operation, and each has its own parameters.
More information on file format, available wrangler types, and the required and/or
optional parameters for each are in [data_wrangle_matrix](data_wrangle_matrix.md).

## Run tutorial

Initiate the process with the following:

```zsh
./run_tutorial.sh  wrangle_matrix  data/config/wrangle_matrix.json
```

## Output

This process outputs a file containing the modified matrix and any optional logfiles 
and reports specified in the Script parameter file. 

## Step 2: Calculate stats with the updated Matrix and associated Tree (calculate_pam_stats) 

