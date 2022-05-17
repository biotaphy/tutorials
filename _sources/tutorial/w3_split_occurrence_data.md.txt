# Resolve taxonomy in a Darwin Core Archive (DwCA)

Webinar 2, [Resolving Nomenclature](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U)
(Module 2, map acquired names for consistency)

Webinar 3, [Data Munging](https://docs.google.com/document/d/1CqYkCUlY40p8NnqM-GtcLju70jrAG45FGejJ26sS3_U/edit#heading=h.eax09dyp58l1) 
(Module 2, Big-Data approaches)

## Introduction

Read [Tutorial Overview](../tutorial/w1_overview.md) for an overview of how all tutorials work. 

## Data Preparation

### DwCA input data
The split_occurrence_data tool accepts either a Darwin Core Archive (DwCA) file or a CSV file containing records for 
one or more taxa.  For this tutorial, the example configuration file works on a DwCA from iDigBio.  To download from 
iDigBio, full instructions are at the 
[iDigBio Download API reference](https://www.idigbio.org/wiki/index.php/IDigBio_Download_API).

To pull data from the command prompt, use the `curl` command to pull text response directly to terminal with the 
example query_url:
[Euphorbia](https://api.idigbio.org/v2/download/?rq=%7B%22genus%22%3A%22euphorbia%22%7D&email=donotreply%40idigbio.org)
```zsh
$ curl https://api.idigbio.org/v2/download/?rq=%7B%22genus%22%3A%22euphorbia%22%7D&email=donotreply%40idigbio.org
[1] 58979
astewart@murderbot:~/git/tutorials$ {
  "complete": false, 
  "created": "2022-05-02T15:28:41.730968+00:00", 
  "expires": "2022-06-01T15:28:41.628063+00:00", 
  "hash": "18911492e8517926cb8693fc9f971cf066107016", 
  "query": {
    "core_source": "indexterms", 
    "core_type": "records", 
    "form": "dwca-csv", 
    "mediarecord_fields": null, 
    "mq": null, 
    "record_fields": null, 
    "rq": {
      "genus": "euphorbia"
    }
  }, 
  "status_url": "https://api.idigbio.org/v2/download/d54c0ad7-6697-4096-9f11-b2a9a6041a38", 
  "task_status": "PENDING"
}
```

Then use `curl` on the resulting **status_url** field:
```zsh
$ curl https://api.idigbio.org/v2/download/d54c0ad7-6697-4096-9f11-b2a9a6041a38
{
  "complete": false, 
  "created": "2022-05-02T15:28:41.730968+00:00", 
  "expires": "2022-06-01T15:28:41.735029+00:00", 
  "hash": "18911492e8517926cb8693fc9f971cf066107016", 
  "query": {
    "core_source": "indexterms", 
    "core_type": "records", 
    "form": "dwca-csv", 
    "mediarecord_fields": null, 
    "mq": null, 
    "record_fields": null, 
    "rq": {
      "genus": "euphorbia"
    }
  }, 
  "status_url": "https://api.idigbio.org/v2/download/d54c0ad7-6697-4096-9f11-b2a9a6041a38", 
  "task_status": "PENDING"
}
```

When the task_status shows "SUCCESS": 
```zsh
$ curl https://api.idigbio.org/v2/download/d54c0ad7-6697-4096-9f11-b2a9a6041a38
{
  "complete": true, 
  "created": "2022-05-02T15:28:41.730968+00:00", 
  "download_url": "http://s.idigbio.org/idigbio-downloads/d54c0ad7-6697-4096-9f11-b2a9a6041a38.zip", 
  "expires": "2022-06-01T15:28:41.552351+00:00", 
  "hash": "18911492e8517926cb8693fc9f971cf066107016", 
  "query": {
    "core_source": "indexterms", 
    "core_type": "records", 
    "form": "dwca-csv", 
    "mediarecord_fields": null, 
    "mq": null, 
    "record_fields": null, 
    "rq": {
      "genus": "euphorbia"
    }
  }, 
  "status_url": "https://api.idigbio.org/v2/download/d54c0ad7-6697-4096-9f11-b2a9a6041a38", 
  "task_status": "SUCCESS"
}
```

Save the response into a file with the `wget` command and the **download_url** field:
```zsh
$ wget http://s.idigbio.org/idigbio-downloads/d54c0ad7-6697-4096-9f11-b2a9a6041a38.zip
```

### Configuration file

The split_occurrence_data configuration file consists of one or more "wrangler_type"s, 
and= the wrangler-specific required and possibly optional parameters for each.  
Available wrangler_types with their parameters are listed 
[here](occurrence_wrangler_config.md)

### Occurrence Data Wranglers

* A configuration file is in JSON format, a list of one dictionary per desired wrangler.
  * Each dictionary must contain "wrangler_type", with the name of the wrangler types (listed below).
  * The dictionary will also contain all required parameters and any optional parameters.

* Currently, wrangler names correspond to the wrangler class `name` attribute in this module's files.
* Each wrangler's parameters correspond to the constructor arguments for that wrangler.
* The [Occurrence Data Wrangler Types](occurrence_wrangler_config.md) page contains a list of all occurrence data 
  wrangler_types and the required and/or optional parameters for each.
* An example split_occurrence_data wrangler configuration, used for this tutorial is 
  [here](../../input/wrangler_conf_split_occurrence_data.json):

```json lines

```

## Run split_occurrence_data tutorial 

Initiate the clean occurrences process with the following:

for linux/mac systems

```zsh
bash run_tutorial.sh split_occurrence_data data/param_config/split_occurrence_data.json
```

for windows systems

```cmd
./run_tutorial.bat split_occurrence_data data\param_config\split_occurrence_data.json
```
