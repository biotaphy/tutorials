# Resolve taxonomy in a Darwin Core Archive (DwCA)

## Request a DwCA from iDigBio
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
