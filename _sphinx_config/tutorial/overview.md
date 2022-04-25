# Common tutorial properties

## Introduction

Each tutorial can be initiated by running the "go" script with 2 arguments at the top level of this project.
The first argument is the command name, and the second is the configuration file containing command arguments, 

i.e. for linux/mac systems

```zsh
bash go.sh clean_occurrences data/input/clean_occurrences.ini
```

for windows systems

```cmd
./go.bat clean_occurrences data\input\clean_occurrences.ini
```

Each configuration file is an ini file with command-specific parameters.  Every command has an example configuration 
file, which references example data.

The "go" script will build and instantiate a Docker container, and run the specified command with the parameters in 
the specified configuration file.

On docker instantiation, the files in the data directory will be shared from the host computer to the docker container.  

Data placed in the input directory on the host machine will be accessible to the container.  Data created by the 
container in the output and log directories will be accessible by the host computer when the container has completed.

Command-specific json-format configuration files define command parameters that can be configured for various tools.