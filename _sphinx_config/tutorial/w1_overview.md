# Biotaphy Tutorials

## Introduction

These tutorials step through the process of running a Biotaphy tool (or command) with 
example data.  There are several entry points to the tools.  These tutorials cover 
running them through: 

1. Docker
2. R Studio (in preparation)

## Preparation

To run Biotaphy tools on any OS, locally through Docker, first download and install 
[Docker](https://docs.docker.com/get-started/).

## Host and Container input, output, log directories 

A named volume `data`, is created on the host machine, and the data directory in this  
repository is copied to it, then mounted at /volumes/data in the container.  This 
volume is read-only, and can only be modified from the host.  If modified, the docker
installation must be re-created to propogate those changes to the containers.  

A named volume `output` is created on the host machine and mounted at /volumes/output
in the container.  Changes in this directory are saved in the volume, and accessible
in the `????` directory on the host machine.

## Data preparation: Configuration File

All tools require a parameters JSON file , with tool-specific parameters.  The file must 
be in JSON format, with parameter names enclosed in double quotes, and string values 
enclosed in double quotes.  Each tutorial contains an example configuration file in the 
docker/<tool_name> directory.  The example configuration files reference example 
data and parameters reasonable for that data.  All required and optional parameters 
are described in individual tutorial pages.

Input and output files referenced in the configuration file are intended for the Docker 
container, so use directory paths specific to the container.  Output file parameters 
(log files, data files) must be specified to be written to /volumes/output and 
/volumes/output/log directories, as they will then also be visible to the host computer 
upon completion.

## Script preparation

Change the permissions on run_tutorial.sh or run_tutorial.bat to allow execution

```zsh
chmod a+x run_tutorial.sh 
```

## Run tool tutorials

The "run_tutorial" script will run each tutorial with two arguments,  
the 1) command name and 2) configuration file.  For example, the  wrangle_species_list 
tutorial can be initiated with: 

for linux/mac systems

```zsh
./run_tutorial.sh wrangle_species_list data/config/resolve_list_names.json
```

for windows systems

```cmd
run_tutorial.bat data\config\resolve_list_names.json
```

## Behind the scenes

The "run_tutorial" script will: 

1. Create (if they do not exist) volumes to share data between the host and container.
2. Build (if it does not exist) and start a Docker container.
3. Files placed in the data/input directory on the host machine will be copied to the 
   /volumes/input directory in the container.
4. Run the specified command with the parameters in the specified configuration file.
5. Outputs and logs created by the process will be written to the /volumes/output  
   directory. 
6. On command completion, the Docker container will stop running.
7. The outputs and logs will be present in the directory `????` on the host computer.  

Some tools will require an additional JSON-format configuration files.  In these cases, 
the JSON file will be identified in the command-configuration file.

## Summary of tutorial commands

```zsh
./run_tutorial.sh wrangle_species_list  data/config/resolve_list_names.json
./run_tutorial.sh wrangle_tree data/config/resolve_tree_names.json
./run_tutorial.sh wrangle_occurrences  data/config/resolve_occurrence_names.json
./run_tutorial.sh split_occurrence_data  data/config/split_occurrence_data.json
./run_tutorial.sh clean_occurrences  data/config/clean_occurrences.json
./run_tutorial.sh build_grid  data/config/build_shapegrid.json
./run_tutorial.sh encode_layers  data/config/encode_layers.json
./run_tutorial.sh calculate_pam_stats  data/config/calc_pam_stats.json
```

