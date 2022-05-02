# Resolve taxonomy in a Darwin Core Archive (DwCA)

Webinar 2, [Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.954n7zxfop57) 
(Module 2, Big-Data approaches)

Webinar 3, [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.h2w2s5gw2n6t)
(Module 2, map acquired names for consistency)

## Introduction

Read [Tutorial Overview](../tutorial/overview.md) for an overview of how all tutorials work. 

## Data Preparation: Request a DwCA from iDigBio
Request a DwCA from iDigBio using their 
[iDigBio Download API](https://www.idigbio.org/wiki/index.php/IDigBio_Download_API).  
Example: 
[Euphorbia](https://api.idigbio.org/v2/download/?rq=%7B%22genus%22%3A%22euphorbia%22%7D&email=donotreply%40idigbio.org)

The response  status via the resulting status_url.  When status response task_status == SUCCESS, pull via included 
download_url.

```zsh
# pull text response directly to terminal using curl
curl <query_url>
curl <status_url>
# save response into file with wget 
wget <download_url>
```

## Configuration file

The split_occurrence_data configuration file consists of one or more "wrangler_type"s, and= the wrangler-specific 
required and possibly optional parameters for each.  Below are the available wrangler_types. 

### Occurrence Data Wranglers

* A configuration file is in JSON format, a list of one dictionary per desired wrangler.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler types (listed below).
  * The dictionary will also contain all required parameters and any optional parameters.

* Currently, wrangler names correspond to the wrangler class `name` attribute in this module's files.
* Each wrangler's parameters correspond to the constructor arguments for that wrangler.
* Below is a list of data wrangler_types and the required and/or optional parameters for each.
* Example clean_occurrences wrangler configuration:


## Run split_occurrence_data tutorial 

Initiate the clean occurrences process with the following:

for linux/mac systems

```zsh
bash go.sh split_occurrence_data data/input/split_occurrence_data.ini
```

for windows systems

```cmd
./go.bat split_occurrence_data data\input\split_occurrence_data.ini
```
