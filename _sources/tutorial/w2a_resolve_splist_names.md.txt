# Resolve names in a list

**Webinar #2** 
[Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.vyth2pntju9l)
Creating name-map 

## Introduction



Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all 
tutorials work. 


## Data preparation

### Input: species list 

Options:

1) Create your own species list, a text file with one name per line.  One resource is
[World Flora Online, WFO](http://www.worldfloraonline.org/)
2) A species list from GBIF (query for heuchera)
   https://www.gbif.org/occurrence/search?taxon_key=3032645&occurrence_status=present
   GBIF.org (19 May 2022) GBIF Occurrence Download  https://doi.org/10.15468/dl.kbdpd7

### Configuration File

A JSON configuration file is required for this command.  These are the required and 
optional parameters: 

* Optional 

  * **log_filename**: Output filename to write logging data
  * **log_console**: 'true' to write log to console
  * **report_filename**: output filename with data modifications made by wranglers

* Required:

  * **in_species_list_filename**: Input filename containing species list.
  * **wrangler_configuration_file**: species list data wrangler configuration file 
  * **out_species_list_filename**: output filename for resulting resolved species list.

An example configuration file to process the saxifragales.txt species list, using the 
AcceptedNameSpeciesListWrangler data wrangler specified in wrangle_list_names.json.  

```json lines
{
  "log_filename": "/volumes/output/resolve_list_names.log",
  "log_console": true,
  "report_filename": "/volumes/output/resolve_list_names.rpt",
  "in_species_list_filename": "/volumes/data/input/heuchera.txt",
  "wrangler_configuration_file": "/volumes/data/config/wrangle_list_names.json",
  "out_species_list_filename": "/volumes/data/input/heuchera_accepted.txt"
}
```

### Input: Wrangler configuration file

A file specifying 0 or more wranglers to apply to the species list data, and options 
specific to each.   

The resolve_list_names.json  configuration file consists of zero or more Species List 
Data Wranglers (wrangler_type), and the wrangler-specific required and possibly optional 
parameters for each.  Configuration files:
  * are in JSON format, a list of one dictionary per desired wrangler.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler types.
  * The dictionary will also contain all required parameters and any optional parameters.
  * A list of species list wrangler_types and the required and/or optional parameters 
    for each are [here](species_list_wrangler.md)

## Run tutorial

Initiate the process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh  wrangle_species_list  data/config/resolve_list_names.json
```

for windows:

```cmd
run_tutorial.bat  wrangle_species_list  data\config\resolve_list_names.json
```

## Output

This process outputs a text file containing the modified species list, one name per 
line.  Current available taxonomic services include only GBIF at this time.

```python
import argparse
import lmpy
from copy import deepcopy
import json
from lmpy.data_wrangling.factory import WranglerFactory
from lmpy.tools._config_parser import _process_arguments, get_logger
from lmpy.tree import TreeWrapper

tree_fn = "../tutorials/data/input/subtree-ottol-saxifragales.tre"
conf_fn = "../tutorials/data/param_config/wrangle_tree_names.json"
conf_fn = "../tutorials/data/param_config/wrangle_treenames.json"
conf_fn = "/volumes/param_config/resolve_list_names.json"

parser = argparse.ArgumentParser(prog='wrangle_species_list')
parser.add_argument('--config_file', type=str, help='Path to configuration file.')
parser.add_argument(
    '--log_filename',
    '-l',
    type=str,
    help='A file location to write logging data.'
)
parser.add_argument(
    '--log_console',
    action='store_true',
    default=False,
    help='If provided, write log to console.'
)
parser.add_argument(
    '-r',
    '--report_filename',
    type=str,
    help='File location to write the wrangler report.'
)
parser.add_argument(
    'in_species_list_filename', type=str, help='Path to the input SpeciesList.'
)
parser.add_argument(
    'wrangler_configuration_file',
    type=str,
    help='Path to Matrix wrangler configuration.',
)
parser.add_argument(
    'out_species_list_filename', type=str, help='Path to the outut SpeciesList.'
)

args = _process_arguments(parser, 'config_file')
logger = get_logger(
    'wrangle_occurrences',
    log_filename=args.log_filename,
    log_console=args.log_console
)

# Get wranglers
wrangler_factory = WranglerFactory(logger=logger)
wranglers = wrangler_factory.get_wranglers(
    json.load(open(args.wrangler_config_filename, mode='rt'))
)

>>>>>>> 96128619ae4020ef6bd751e4ace5df25b4989533

tree = TreeWrapper.get(path=tree_fn, schema="newick")
wrangler_factory = WranglerFactory()
with open(conf_fn, mode="rt") as in_json:
    wranglers = wrangler_factory.get_wranglers(json.load(in_json))

wrangler = wranglers[0]
wtree = wrangler.wrangle_tree(tree)

dir(wtree.taxon_namespace)

for taxon in wtree.taxon_namespace:
    
```