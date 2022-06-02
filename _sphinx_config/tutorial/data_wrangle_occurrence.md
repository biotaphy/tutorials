# Specimen Occurrences

## Occurrence Data

Several tools ([split_occurrence_data](w3_split_occurrence_data.md),
[wrangle_occurrences](w2c_resolve_occurrence_names.md)) accept occurrence data.
The filename must be specified in the script parameter file, described in each tool's
documentation and linked above.  Data can be in one of two formats:

1) Darwin Core Archive (DwCA) file.  DwCA files may be downloaded from several places,
   including GBIF and iDigBio.

   1) To download from GBIF, choose your filters in the
      [portal](https://www.gbif.org/occurrence).  For example, the example data was
      downloaded after selecting occurrences where
      [genus=`Heuchera L`](https://www.gbif.org/occurrence/search?taxon_key=3032645&occurrence_status=present)
      Then choose the download link at the upper right column header.
   2) To download from iDigBio, instructions for querying and downloading from the
      command prompt are at [idigbio_download.md](./idigbio_download.md).
   3) The tutorial example DwCA is at
      [occ_heuchera_gbif.zip](../../data/input/occ_heuchera_gbif.zip).

2) CSV file containing records for one or more taxa.

   1) A CSV file is a text file with one species occurrence record per line.  The file
      must be a delimited text file, and the first line must contain field names.  Each
      record/line must contain a species (or other group) identifier, such as
      scientificName or species_name, and x and y coordinates indicating a geographic
      location.  The field names for these 3 columns are specified in the script
      parameter file. The tutorial example occurrence datafile
      is [heuchera.csv](../../data/input/heuchera.csv).

## Occurrence Wrangler Types

When running wranglers on an occurrence data set, wranglers are applied in the order
that they are listed in the wrangler config file.

Note that some wranglers (MinimumPointsWrangler, UniqueLocalitiesFilter) assess the 
counts over the entire file/dataset, not subsets within a file.  So if wrangling an 
occurrence record file that contains multiple groups of records, the wrangler will not 
assess the minimum number of points or unique localities for each group, it will do that
for the dataset as a whole.  This is not recommended.

Currently, wrangler_type names correspond to the wrangler class `name` attribute in
this module's files.  Each wrangler's parameters correspond to the constructor
arguments for that wrangler.

### AcceptedNameOccurrenceWrangler

* optional

  * name_map (str or dict): A dictionary or filename containing a dictionary of original 
    name to accepted name.  Defaults to None, but either this or name_resolver 
    **must be** provided.
  * name_resolver (str or Method): Use this method for getting new
    accepted names. If set to 'gbif' or 'otol', use GBIF or OTOL name resolution
    respectively.  Defaults to None, but either this or name_map must be provided.
  * out_map_filename (str): Output for name-mapping between original and accepted names.
    This file is then acceptable for use as a **name-map** input for subsequent
    name wrangling.  Defaults to None.
  * map_write_interval (int): Interval at which to write records to disk.  Used to
    ensure that if something fails, all is not lost. Defaults to 100.
  * out_map_format (str): Type of file format for out_map_filename, defaults to "json".
  * store_original_attribute (str): A new attribute to store the original taxon name.

### AttributeFilterWrangler

* required

  * attribute_name (str): The name of the attribute to modify.
  * filter_func (Method): A function to be used for the pass condition.

### AttributeModifierWrangler

* required

  * attribute_name (str): The name of the attribute to modify.
  * attribute_func (Method): A function to generate values for a point.

### BoundingBoxFilter

* required

  * min_x (numeric): The minimum 'x' value for the bounding box.
  * min_y (numeric): The minimum 'y' value for the bounding box.
  * max_x (numeric): The maximum 'x' value for the bounding box.
  * max_y (numeric): The maximum 'y' value for the bounding box.

### CommonFormatWrangler

* required

  * attribute_map (dict): A mapping of source key, target values.

### CoordinateConverterWrangler

* required

  * target_epsg (int): Target map projection specified by EPSG code.

* optional

  * source_epsg (int): Source map projection specified by EPSG code.
  * epsg_attribute (str or None): A point attribute containing EPSG code.
  * original_x_attribute (str): An attribute to store the original x value.
  * original_y_attribute (str): An attribute to store the original y value.

### DecimalPrecisionFilter

* required:

  * decimal_places (int): Only keep points with at least this many decimal places of
    precision.

### DisjointGeometriesFilter'

* required:

  * geometry_wkts (list of str): A list of geometry WKTs to check against.

### IntersectGeometriesFilter

* required:

  * geometry_wkts (list of str): A list of WKT strings.

### MinimumPointsWrangler

Note: This point must only be used on occurrence data file that is to be used as a 
single group of records, i.e. a file containing only one species or grouping.  When  
wrangling multi-species datasets, this will count the number of points for the entire  
set, not subsets within a file.

* required:

  * minimum_count (int): The minimum number of points in order to keep all.

### SpatialIndexFilter

* required:

  * spatial_index (SpatialIndex): A SpatialIndex object that can be searched.
  * intersections_map (dict): A dictionary of species name keys and corresponding valid
    intersection values.
  * check_hit_func (Method): A function that takes two arguments (search hit, valid
    intersections for a species) and returns a boolean indication if the hit should be
    counted.

### UniqueLocalitiesFilter

Note: This point must only be used on occurrence data file that is to be used as a 
single group of records, i.e. a file containing only one species or grouping.  When  
wrangling multi-species datasets, this will count the unique localities for the entire  
set, not subsets within a file

* optional parameters:

  * do_reset (bool): Reset the list of seen localities after each group.
