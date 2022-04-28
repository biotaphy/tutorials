# Build grid

## Introduction

Read [Tutorial Overview](../tutorial/overview.md) for an overview of how all tutorials work. 

## Run clean_occurrences tutorial 

Initiate the build_shapegrid process with the following:

for linux/mac systems

```zsh
bash go.sh build_shapegrid data/input/build_shapegrid.ini
```

for windows: 
```cmd
go.bat build_shapegrid data\input\build_shapegrid.ini
```

## Configuration file

The clean_occurrences configuration file consists of 7 required parameters: 
* **shapegrid_filename**: The relative or absolute path for the output shapegrid.
* **min_x**: The minimum value for X (longitude) coordinate of the shapegrid.
* **min_y**: The minimum value for Y (latitude) coordinate of the shapegrid.
* **max_x**: The maximum value for X (longitude) coordinate of the shapegrid.
* **max_y**: The maximum value for Y (latitude) coordinate of the shapegrid.
* **cell_size**: The size of each cell (in units indicated by EPSG).
* **epsg**: The EPSG code for the new shapegrid.
