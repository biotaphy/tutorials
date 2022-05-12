# Tree Data Wrangler types

When running wranglers on a tree, wranglers are applied in the order 
that they are listed in the wrangler config file.  

Currently, wrangler_type names correspond to the wrangler class `name` attribute in 
this module's files.  Each wrangler's parameters correspond to the constructor 
arguments for that wrangler.

## AcceptedNameTreeWrangler

* optional

  * name_map (dict): A map of original name to accepted name.
  * name_resolver (str or Method): If provided, use this method for getting new accepted names.
    If set to 'gbif', use GBIF name resolution.
  * purge_failures (bool): Should failures be purged from the tree.

## MatchMatrixTreeWrangler

* required

  * matrix (str): The filename of a matrix to match.
  * species_axis (int): An integer indicating which axis contains species names.  
    Biotaphy matrices are two-dimensional, with sites (locations) in the 0 axis 
    (rows/y axis), and species in the 1 axis (columns/x axis)

## SubsetTreeWrangler

* required
  
  * keep_taxa (list of str): A list of taxon names to keep.
