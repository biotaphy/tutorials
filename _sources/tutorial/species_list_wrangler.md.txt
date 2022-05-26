# Species List Data Wrangler types

When running wranglers on an occurrence data set, wranglers are applied in the order 
that they are listed in the wrangler config file.  

Currently, wrangler_type names correspond to the wrangler class `name` attribute in 
this module's files.  Each wrangler's parameters correspond to the constructor 
arguments for that wrangler.

## AcceptedNameSpeciesListWrangler

* optional
  
  * name_map (dict): A map of original name to accepted name.  Defaults to None, but 
    either this or name_resolver **must be provided**.
  * name_resolver (str or Method): Use this method for getting new 
    accepted names. If set to 'gbif' or 'otol', use GBIF or OTOL name resolution 
    respectively.  Defaults to None, but either this or name_map must be provided.
  * out_map_filename (str): Output for name-mapping between original and accepted names.
    This file is then acceptable for use as a **name-map** input for subsequent  
    name wrangling.  Defaults to None.
  * map_write_interval (int): Interval at which to write records to disk.  Used to 
    ensure that if something fails, all is not lost. Defaults to 100.
  * out_map_format (str): Type of file format for out_map_filename, defaults to "json".

## IntersectionSpeciesListWrangler

* required
  
  * species_list (str): Filename containing species list to intersect 

## MatchMatrixSpeciesListWrangler

* required
  
  * matrix (str): Filename containing matrix to match

## MatchTreeSpeciesListWrangler

* required
  
  * tree (str): Filename containing tree to match

## UnionSpeciesListWrangler

* required

  * species_list (str): Filename containing species list to join 

# Wrangler configuration file

A file specifying 0 or more wranglers to apply to the species list, and options 
specific to each.  Configuration files:

  * are in JSON format, a list of desired wranglers.
  * Each wrangler is a dictionary.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler type.
  * The dictionary will also contain all required parameters and any optional parameters.
