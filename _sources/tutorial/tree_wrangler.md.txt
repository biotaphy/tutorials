# Tree Data Wrangler types

When running wranglers on a tree, wranglers are applied in the order 
that they are listed in the wrangler config file.  

Currently, wrangler_type names correspond to the wrangler class `name` attribute in 
this module's files.  Each wrangler's parameters correspond to the constructor 
arguments for that wrangler.

## AcceptedNameTreeWrangler

* optional
  
  * name_map (dict): A map of original name to accepted name.    Defaults to None, but 
    either this or name_resolver must be provided.
  * name_resolver (str or Method): Use this method for getting new 
    accepted names. If set to 'gbif' or 'otol', use GBIF or OTOL name resolution 
    respectively.  Defaults to None, but either this or name_map must be provided.
  * out_map_filename (str): Output for name-mapping between original and accepted names.
    This file is then acceptable for use as a **name-map** input for subsequent  
    name wrangling.  Defaults to None.
  * map_write_interval (int): Interval at which to write records to disk.  Used to 
    ensure that if something fails, all is not lost. Defaults to 100.
  * out_map_format (str): Type of file format for out_map_filename, defaults to "json".
  * purge_failures (bool): Should failures be purged from the tree.

## MatchMatrixTreeWrangler

* required

  * matrix (str): The filename of a matrix to match.
  * species_axis (int): An integer indicating which axis contains species names.  
    Biotaphy matrices are two-dimensional, with sites (locations) in the 0 axis 
    (rows/y axis), and species in the 1 axis (columns/x axis)

## MatchSpeciesListTreeWrangler

* required

  * species_list (str): Input file containing a species list to match

## SubsetTreeWrangler

* required
  
  * keep_taxa (list of str): A list of taxon names to keep.

# Wrangler configuration file

A file specifying 0 or more wranglers to apply to the tree data, and options 
specific to each.  Configuration files:

  * are in JSON format, a list of desired wranglers.
  * Each wrangler is a dictionary.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler type.
  * The dictionary will also contain all required parameters and any optional parameters.
