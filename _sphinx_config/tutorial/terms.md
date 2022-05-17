---
title: Terminology
image_path: ""
layout: page
---
# Contents
{:.no_toc}

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

# Geospatial data

Geospatial data is data with geographic location associated with it, i.e. map
data.  There are two kinds of spatial data, raster data and vector data.  Each
has properties that make it better for representing different information.

## Raster Data

Geospatial data best represented in raster format generally has one value at 
every point.  The area to be represented is split up into a grid, with each 
grid cell containing a value. Elevation, temperature, precipitation are 
examples of data generally represented as raster.

## Vector Data

Geospatial data best represented in vector format can be represented as points, 
lines, or polygons.  

**Point**: Points represent a single location on a 2 dimensional surface.  
Depending on the scale, different types of data are appropriate to be 
represented as points. At a very small scale (think of from a very great 
distance), a city might be represented as a single point.  Species occurrences 
are usually represented as points.

**Line**: Lines are made up of multiple points, joined.  Roads and rivers are 
usually represented as rivers.  

**Polygon**: Polygons are made up of multiple points or lines, joined to define 
a discrete area.  At a larger scale (zoomed in), a city, river, or street might 
be represented as a polygon. Administrative boundaries, like country, state, or 
other geo-political units are examples of polygon data.

## Scale

Large scale maps refer to maps of a small area with a large amount of detail.  
The ratio between distance on the map to distance on the ground is very large.  
For example a detailed map of a city might be at 1:5000, meaning that 1 unit on 
the map (i.e. centimeter) equals 5000 units on the ground (5000 centimeters).  
A smaller scale map, for example a regional map used for land-management, might
be at a scale of 1:100,000 (1 centimeter = 1 kilometer).

Small scale maps are generally used for mapping large areas.  The ratio of the 
distance on the map to the distance on the ground is much smaller.  For example, 
a map of the country of Indonesia might be at the ratio of 1:2,000,000.


## Sample Geospatial Data resources

* [World borders]  (http://thematicmapping.org/downloads/world_borders.php)

* [Global administrative boundaries]  http://www.gadm.org/country)

* [Natural earth data] (http://www.naturalearthdata.com/)


# Species Analysis Terms

Algorithm
: An algorithm is a procedure or formula for solving a problem.  There are  multiple 
  algorithms for computing Species Distribution Models (SDM) which 
  define the relationship between a set of points and the environmental values 
  at those points.

Occurrence Data
: Point data representing specimens collected for a single species or taxa.  Data
  contains a location, x and y, in some known geographic spatial reference system.
  Public data in BiotaPhy installations are in the 'Geographic' spatial 
  reference system, latitude and longitude in decimal degrees. 

Environmental Layer
: Raster data representing environmental values for cells in a map.  Data
  may be numeric or categorical, with only one value per cell.
  Public data in BiotaPhy installations are in the 'Geographic' spatial 
  reference system, latitude and longitude in decimal degrees. 

SDM
: Species Distribution Modeling (SDM) is also known by several other names, including 
  environmental niche modeling, ecological niche modeling, and habitat modeling.  
  SDM refers to the process of creating mathematical formulas (models) to predict the 
  geographic distribution of species based on where they have been found and the 
  environmental conditions in those locations.

Presence-Absence Matrix (PAM)
: A binary matrix containing species distributions of 0/1 indicating presence or 
  non-presence in each grid cell of a region. The matrix may be thought of as a 
  three-dimensional cube, of binary maps, with one layer per species.  The 3-dimensional 
  matrix is flattened into 2 dimensions, with rows representing sites with an x,y 
  coordinate for the center of a gridcell on a map, and columns representing 
  species.  

Phylogenetic Tree
: A data structure containing species names or identifiers for  analyzing 
  evolutionary patterns.  BiotaPhy uses phylogenetic trees matching species
  data in a gridset to correlate evolutionary patterns with species 
  distributions and landscape features.  

Ultrametric Tree
: A tree whose total branch length from the root to each tip in the tree is the same.

Biogeographic Hypotheses
: Spatial layers for testing the influence of geographic elements, such as
  geology, drainage basins, etc, on the biodiversity of a landscape. These 
  can be in the form of raster or vector files.  
   
MCPA
: Meta-Community Phylogenetic Analysis (MCPA, Leibold et al, 2010) is a "method that  
  aims to evaluate the interaction between phylogenetic structure, historical 
  biogeographic events and environmental filtering in driving species distributions in 
  a large-scale metacommunity".   


# BiotaPhy-specific Data and Parameter Terms

Shapegrid
: A grid encompassing the area of interest in a Gridset for multi-species
  analyses. In a gridset, different data layers are intersected with a Shapegrid 
  to produce Matrices for analyses.  Species layers are intersected to
  create a PAM, environmental layers are intersected to create an Environmental 
  Matrix (GRIM) and Biogeographic Hypotheses are intersected to create a BioGeo
  Matrix. Intersection parameters define how values are computed for gridcells 
  from the values in data layers. 

# References

Leibold, M. A., Economo, E. P., & Peres‐Neto, P. (2010). Metacommunity 
phylogenetics: separating the roles of environmental filters and historical 
biogeography. Ecology letters, 13(10), 1290-1299.
[doi:10.1111/j.1461-0248.2010.01523.x](https://doi.org/10.1111/j.1461-0248.2010.01523.x)
