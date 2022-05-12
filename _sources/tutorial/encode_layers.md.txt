# Encode Layers

Webinar 7 [Introducing PAMs](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.3y36cau4jutj)

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all tutorials 
work. 

### Configuration File

An example json file for running the encode_layers tutorial is at 
../../data/param_config/encode_layers.json. These are the required and optional 
parameters:

* Required: 
  * **shapegrid_filename**: Relative path to shapegrid to use for site geometries
  * **out_matrix_filename**: Relative path to write the encoded matrix
* Optional 
  * **min_coverage**: Minimum percentage of a cell that has to be covered to encode it
  * **min_presence**: Minimum value to be considered present when encoding presence 
    absence
  * **max_presence**: Maximum value to be considered present
  * **layer**: list of a 
    * layer filename
    * (optional) label for the encoded layer in the output matrix. Defaults to file 
        basename
    * (optional) attribute 

## Run encode_layers tutorial 

Initiate the clean occurrences process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh encode_layers data/param_config/encode_layers.ini
```

for windows systems

```cmd
./run_tutorial.bat encode_layers data\param_config\encode_layers.ini
```
