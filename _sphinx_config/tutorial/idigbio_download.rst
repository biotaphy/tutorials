#######################################
Download occurrence data from iDigBio
#######################################

===============================
Request data
===============================
To download from iDigBio, full instructions are at the
`Download API reference <https://www.idigbio.org/wiki/index.php/IDigBio_Download_API>`_.

To pull data from the command prompt, use the `curl` command to pull text response
directly to terminal with the example query_url:
`Euphorbia
<https://api.idigbio.org/v2/download/?rq=%7B%22genus%22%3A%22euphorbia%22%7D&email=donotreply%40idigbio.org>`_

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

===============================
Determine download readiness
===============================
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

===============================
Download data
===============================
Save the response with the `curl` command and the **download_url** field.  Use the
--output option to save the data to a file.

```zsh
curl --output idigbio_occurrences.zip  http://s.idigbio.org/idigbio-downloads/d54c0ad7-6697-4096-9f11-b2a9a6041a38.zip
```
