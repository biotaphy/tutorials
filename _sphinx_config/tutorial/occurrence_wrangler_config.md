# Occurrence Data Wrangler types

When running wranglers on an occurrence data set, wranglers are applied in the order 
that they are listed in the wrangler config file.  

Currently, wrangler_type names correspond to the wrangler class `name` attribute in 
this module's files.  Each wrangler's parameters correspond to the constructor 
arguments for that wrangler.

## AcceptedNameOccurrenceWrangler
* optional
  * name_map (dict): A map of original name to accepted name.
  * name_resolver (str or Method): If provided, use this method for getting new accepted names.
    If set to 'gbif', use GBIF name resolution.
  * store_original_attribute (str): A new attribute to store the
    original taxon name.

## AttributeFilterWrangler
* required
  * attribute_name (str): The name of the attribute to modify.
  * filter_func (Method): A function to be used for the pass condition.

## AttributeModifierWrangler
* required
  * attribute_name (str): The name of the attribute to modify.
  * attribute_func (Method): A function to generate values for a point.

## BoundingBoxFilter
* required
  * min_x (numeric): The minimum 'x' value for the bounding box.
  * min_y (numeric): The minimum 'y' value for the bounding box.
  * max_x (numeric): The maximum 'x' value for the bounding box.
  * max_y (numeric): The maximum 'y' value for the bounding box.

## CommonFormatWrangler
* required
  * attribute_map (dict): A mapping of source key, target values.

## CoordinateConverterWrangler
* required
  * target_epsg (int): Target map projection specified by EPSG code.
* optional
  * source_epsg (int): Source map projection specified by EPSG code.
  * epsg_attribute (str or None): A point attribute containing EPSG code.
  * original_x_attribute (str): An attribute to store the original x value.
  * original_y_attribute (str): An attribute to store the original y value.

## DecimalPrecisionFilter
* required:
  * decimal_places (int): Only keep points with at least this many decimal places of precision.

## DisjointGeometriesFilter
* required:
  * geometry_wkts (list of str): A list of geometry WKTs to check against.

## IntersectGeometriesFilter
* required:
  * geometry_wkts (list of str): A list of WKT strings.

## MinimumPointsWrangler
* required:
  * minimum_count (int): The minimum number of points in order to keep all.

## SpatialIndexFilter
* required:
  * spatial_index (SpatialIndex): A SpatialIndex object that can be searched.
  * intersections_map (dict): A dictionary of species name keys and corresponding valid intersection values.
  * check_hit_func (Method): A function that takes two arguments (search hit, valid intersections for a species)
    and returns a boolean indication if the hit should be counted.

## UniqueLocalitiesFilter
* optional parameters:
  * do_reset (bool): Reset the list of seen localities after each group.
