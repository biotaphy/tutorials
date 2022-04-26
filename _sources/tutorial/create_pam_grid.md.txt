# Create grid

## Introduction

Each tutorial can be initiated by running the "go" script with 2 arguments at the top level of this project.
The first argument is the command name, and the second is the configuration file containing command arguments, 

i.e. for linux/mac systems

```zsh
bash go.sh create_grid data/input/create_grid.ini
```
        shapegrid_file_name (str): The location to store the resulting
            shapegrid.
        min_x (numeric): The minimum value for X of the shapegrid.
        min_y (numeric): The minimum value for Y of the shapegrid.
        max_x (numeric): The maximum value for X of the shapegrid.
        max_y (numeric): The maximum value for Y of the shapegrid.
        cell_size (numeric): The size of each cell (in units indicated by EPSG).
        epsg_code (int): The EPSG code for the new shapegrid.
        cell_sides (int): The number of sides for each cell of the shapegrid.
            4 - square cells, 6 - hexagon cells
        site_id (str): The name of the site id field for the shapefile.
        site_x (str): The name of the X field for the shapefile.
        site_y (str): The name of the Y field for the shapefile.
        cutout_wkt (None or str): WKT for an area of the shapegrid to be cut
            out.
