# Biotaphy Tutorials

## Introduction

These tutorials step through the process of running a Biotaphy tool (or command) with
example data.  There are several entry points to the tools.  These tutorials cover
running them through a command line script, which creates a Docker container, installs
the tools, executes the processes, and returns the outputs to the local machine.

## Preparation

To run Biotaphy tools on any OS, locally through Docker, first download and install
[Docker](https://docs.docker.com/get-started/).

## Host and Container input, output, log directories

A named volume `data`, is created on the host machine, and the data directory in this
repository is copied to it, then mounted at /volumes/data in the container.  This
volume is read-only, and can only be modified from the host.  If modified, the docker
`data` volume must be re-created to propogate those changes to the containers.

A named volume `output` is created on the host machine and mounted at /volumes/output
in the container.  Changes in this directory are saved in the volume, and copied back
to the host machine.

## Data preparation: Tool Configuration File

All commands require a configuration file with tool-specific parameters.  The file
must be in JSON format, with parameter names enclosed in double quotes, and string
values enclosed in double quotes.  Each tutorial contains an example configuration file
in the docker/<tool_name> directory.  The tutorial configuration files reference example
data and parameters reasonable for that data.  All required and optional parameters
are described in individual tutorial pages.

Input and output files referenced in the configuration file are intended for the Docker
container, so directory paths reference volumes mounted in the container.  Output file
parameters (log files, data files) must be in the /volumes/output path, which allows
writing.

[//]: # (## Script preparation)

[//]: # ()
[//]: # (Change the permissions on run_tutorial.sh or run_tutorial.bat to allow execution)

[//]: # ()
[//]: # (```zsh)

[//]: # (chmod a+x run_tutorial.sh )

[//]: # (```)

## Run tool tutorials

The "run_tutorial" script will run each tutorial with two arguments,
the 1) command name and 2) configuration file.  The configuration file will be a path
on the local machine; the script will translate that to the container path, and execute
the command in the container with the container's copy of the file.  For example, the
**wrangle_species_list** tutorial can be initiated with:

for linux/mac systems

```zsh
./run_tutorial.sh wrangle_species_list ./data/config/resolve_list_names.json
```

for windows systems

```cmd
run_tutorial.bat data\config\resolve_list_names.json
```

## Behind the scenes

The "run_tutorial" script will:

1. Create (if they do not exist) volumes to share data between the host and container.
2. Build (if it does not exist) a Docker image.
3. Start (if it is not running) a Docker container from the image, with volumes
   attached.
4. Execute the specified command with the parameters in the specified configuration
   file. directory.  The process will:

   1. read files from the container **/volumes/data** directory
   2. write outputs and logs to the container **/volumes/output** directory

5. Copy the container **/volumes/output** directory back to the local data directory.
6. Stop and delete the container.  All outputs in the docker volume are preserved and
   accessible the next time it is attached to a container.

Some tools will require an additional JSON-format configuration file.  In these cases,
the JSON file will be specified in the command-configuration file.

## Outputs

All outputs are specified in the Tool Configuration File provided to the command, and
will be copied to the data/outputs directory on completion.

## Summary of tutorial commands

Tools can be called with the run_tutorial script:

```zsh
./run_tutorial.sh  <command>  <tool_configuration_file>
```

Sending the command **list_commands** will print all valid commands.

```zsh
./run_tutorial.sh list_commands
./run_tutorial.sh wrangle_species_list  data/config/resolve_list_names.json
./run_tutorial.sh wrangle_tree data/config/resolve_tree_names.json
./run_tutorial.sh wrangle_occurrences  data/config/resolve_occurrence_names.json
./run_tutorial.sh split_occurrence_data  data/config/split_occurrence_data_dwca.json
./run_tutorial.sh clean_occurrences  data/config/clean_occurrences.json
./run_tutorial.sh build_grid  data/config/build_grid.json
./run_tutorial.sh encode_layers  data/config/encode_layers.json
./run_tutorial.sh calculate_pam_stats  data/config/calc_pam_stats.json
```
