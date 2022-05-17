# Biotaphy Tutorials

## Introduction
These tutorials step through the process of running a Biotaphy tool (or command) with example data.  There are 
several entry points to the tools.  These tutorials cover running them through: 
1. Docker
2. R Studio (in preparation)

## Preparation
To run Biotaphy tools on any OS, locally through Docker, first download and install 
[Docker](https://docs.docker.com/get-started/).

## Host and Container input, output, log directories 
The data/input directory on the host machine is copied to the biotaphy_data/input directory in the container.  
Any changes made to the biotaphy_data/input directory in the container will not persist to the host machine.

The data/output and data/log directories on the host machine are accessible to the container as the 
biotaphy_data/output and biotaphy_data/log directories in the container.  These directories are mapped directly, so 
changes made in the container are visible to the host machine.

## Data preparation: Configuration File
All tools require a parameters JSON file , with tool-specific parameters.  The file should be in JSON format, with  
parameter names enclosed in double quotes, and string values enclosed in double quotes.  Each tutorial contains 
an example configuration file in the docker/<tool_name> directory.  The example configuration files reference example 
data and parameters reasonable for that data.  All required and optional parameters are described in individual tutorial
pages.

Input and output files referenced in the configuration file are intended for the Docker container, so use directory 
paths specific to the container.  Output file parameters (log files, data files) must be specified to be written to 
biotaphy_data/output and biotaphy_data/log directories, as they will then also be visible to the host computer upon
completion.

## Run tool tutorials
The "go" script will run each tutorial with two arguments, the 1) command name and 2) configuration file.  
For example, the  clean_occurrences tutorial can be initiated with: 

for linux/mac systems
```zsh
bash run_tutorial.sh clean_occurrences data/param_config/clean_occurrences.json
```

for windows systems
```cmd
./run_tutorial.bat clean_occurrences data\param_config\clean_occurrences.json
```

## Behind the scenes
The "go" script will: 
1. Build and instantiate a Docker container.
2. Files placed in the data/input directory on the host machine will be copied to the biotaphy_data/input directory in
   the container.  
3. The data/output and data/log directories on the host machine are mapped to the biotaphy_data/output and 
   biotaphy_data/log directories in the container.  
4. Run the specified command with the parameters in the specified configuration file.
5. Outputs and logs created by the process will be written to the biotaphy_data/output and biotaphy_data/log 
   directories. 
6. On command completion, the Docker container will stop running.
7. The outputs and logs will be present in the directories data/output and data/log on the host computer.  

Some tools will require an additional JSON-format configuration files.  In these cases, the JSON file will be 
identified in the command-configuration file.