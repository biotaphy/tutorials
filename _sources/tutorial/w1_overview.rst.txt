==============================
Webinar 1: Tutorial Overview
==============================

--------------------------------
Introduction
--------------------------------

These tutorials step through the process of running a Biotaphy tool (or command) with
example data.  There are several entry points to the tools.  These tutorials cover
running them through a command line script, which creates a Docker container, installs
the tools, executes the processes, and returns the outputs to the local machine.

--------------------------------
Preparation
--------------------------------

To run Biotaphy tools on any OS, locally through :term:`Docker`, first download and
install [Docker](https://docs.docker.com/get-started/).

--------------------------------------------------
Host and Container input, output, log directories
--------------------------------------------------

A :term:`Volume` "data", is created on the :term:`Host machine`, and the
tutorials/data/input, tutorials/data/config, and tutorials/data/wranglers directories
in this repository are copied to it.  These directories are then made available on the
term:`Container` under the /volumes/data volume (directory).  This volume is read-only,
and can only be modified from the Host machine prior to building your Container.
If modified, the docker "data" volume must be re-created to propagate those changes to
the containers.

A named volume `output` is created on the :term:`Host machine` and mounted at
/volumes/output in the :term:`Container`.  Changes in this directory are saved in the
volume, and copied back to the host machine, under the data directory.

-------------------------------------------
Data preparation: Script parameters File
-------------------------------------------

All commands require a parameters file with tool-specific parameters.  The file
must be in :term:`JSON` format.  More information is [here](script_params.rst).

Each tutorial contains one or more example parameters files in the tutorials/data/config
directory.  These parameters files reference example data and parameters reasonable for
that command.  All required and optional parameters are described in individual tutorial
pages.

Some tools will require an additional :term:`JSON` format configuration file.  In these
cases, the JSON file will be specified in the parameters file.

-------------------------------------------
Run tool tutorials
-------------------------------------------

The "run_tutorial" script will run each tutorial with two arguments,
the 1) command name and 2) parameters file.  The parameters file will be a path
on the local machine, in the tutorials/data/config directory.  The script will translate
that to the container path, and execute the command in the container with the
container's copy of the file.  For example, the
**wrangle_species_list** tutorial can be initiated with:

for linux/mac systems

.. code-block::

       ./run_tutorial.sh wrangle_species_list ./data/config/wrangle_species_list_gbif.json


-------------------------------------------
Behind the scenes
-------------------------------------------

The "run_tutorial" script will:

1. Create (if they do not exist) :term:`Volume`s to share data between the host and
   container.
2. Build (if it does not exist) a :term:`Docker image`.
3. Start (if it is not running) a Docker :term:`Container` from the image, with volumes
   attached.
4. Execute the specified command with the parameters in the specified configuration
   file. directory.  The process will:

   1. read files from the container **/volumes/data** directory
   2. write outputs and logs to the container **/volumes/output** directory

5. Copy the container **/volumes/output** directory back to the local data directory.
6. Stop and delete the container.  All outputs in the docker volume are preserved and
   accessible the next time it is attached to a container.

-------------------------------------------
Outputs
-------------------------------------------

All outputs are specified in the Tool Configuration File provided to the command, and
will be copied to the data/outputs directory on completion.

-------------------------------------------
Summary of tutorial commands
-------------------------------------------

Tools can be called with the run_tutorial script:

.. code-block::

       ./run_tutorial.sh  <command>  <tool_configuration_file>

Sending the command **list_commands** will print all valid commands.  Below are some
commands with example configurations.

.. code-block::


        # Webinar 1
        ./run_tutorial.sh list_commands
        # Webinar 2
        ./run_tutorial.sh wrangle_species_list  data/config/wrangle_species_list_gbif.json
        ./run_tutorial.sh wrangle_species_list  data/config/wrangle_species_list_namemap.json
        # Webinar 3
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences.json
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences_only_resolve.json
        ./run_tutorial.sh wrangle_occurrences  data/config/wrangle_occurrences_w_resolve.json
        # Webinar 5
        ./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_csv.json
        ./run_tutorial.sh split_occurrence_data data/config/split_occurrence_data_dwca.json
        ./run_tutorial.sh split_occurrence_data data/config/split_wrangle_occurrence_data.json
        # Webinar 6
        ./run_tutorial.sh create_sdm data/config/create_sdm.json
        # Webinar 7
        ./run_tutorial.sh build_grid  data/config/build_grid.json
        ./run_tutorial.sh encode_layers  data/config/encode_layers.json
        ./run_tutorial.sh calculate_pam_stats  data/config/calculate_pam_stats.json
        # Webinar 8
        ./run_tutorial.sh wrangle_tree data/config/wrangle_tree.json

        ./run_tutorial.sh clean_occurrences  data/config/clean_occurrences.json

