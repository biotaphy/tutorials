# Build grid

## Introduction

Read [Tutorial Overview](../tutorial/overview.md) for an overview of how all tutorials work. 

## Data preparation

### Configuration File
An example INI file for running the build_shapegrid tutorial is at 
../../data/input/build_shapegrid.ini. These are the 7 required parameters:

* Required: 
  * **shapegrid_filename**: The relative or absolute path for the output shapegrid.
  * **min_x**: The minimum value for X (longitude) coordinate of the shapegrid.
  * **min_y**: The minimum value for Y (latitude) coordinate of the shapegrid.
  * **max_x**: The maximum value for X (longitude) coordinate of the shapegrid.
  * **max_y**: The maximum value for Y (latitude) coordinate of the shapegrid.
  * **cell_size**: The size of each cell (in units indicated by EPSG).
  * **epsg**: The EPSG code for the new shapegrid.


## Run build_shapegrid tutorial
Initiate the build_shapegrid process with the following:

for linux/mac systems
```zsh
bash go.sh build_shapegrid data/input/build_shapegrid.json
```

for windows: 
```cmd
go.bat build_shapegrid data\input\build_shapegrid.ini
```

## Output
The build_shapegrid tool outputs a grid in shapefile format, conforming to the arguments specified
in the configuration INI file.
