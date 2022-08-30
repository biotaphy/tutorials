===============
Quick Start
===============

-----------------------
Install Docker
-----------------------

Follow instructions for your operating system at
[Get Docker](https://docs.docker.com/get-docker/)

-----------------------
Download Tutorial
-----------------------

The [Biotaphy tutorial](https://github.com/biotaphy/tutorials)  can be installed by
downloading from Github.  This code repository contains scripts, Docker composition
files, and data for the tutorials.

```commandline
git clone https://github.com/biotaphy/tutorials.git
```

-----------------------
Initiate each tutorial
-----------------------

Choose a command to initiate with the default data.  Commands

From the top level project directory (tutorials):

.. code-block:: bash

  docker pull ghcr.io/specifysystems/lmpy:latest

Then you can run the container interactively and call tools with bash

.. code-block:: bash

  docker run -it specifysystems/lmpy:latest bash


-----------------------
Examine results
-----------------------

All outputs from tutorial exercises are copied to the local system in a newly
created `output` directory under the `data` directory in the downloaded `tutorials`
repository.


```commandline
ls ./tutorials/data/output
```