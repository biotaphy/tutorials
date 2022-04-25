# Biotaphy tutorials

## Setup Steps

Before we can run the demo, we need to build the container.  This documentation
assumes that Docker has been installed for your environment 
(see: https://docs.docker.com/get-docker/).

1. Clone or download the repository
```commandline
git clone https://github.com/biotaphy/tutorials.git
```

2. Change to the repository directory
```commandline
cd tutorials
```

3. Run the bash script with a command and configuration file to 
   1. create an environment file 
   2. run the container with command-specific docker-compose and environment files, which
      1. runs the command in the container
      2. creating output files in the container, mounted to the local directory
```zsh
bash go.sh clean_occurrences data/input/clean_occurrences.ini
```

Image tutorials_back-end is now available

4. Run a bash shell in the container interactively

Mac / Linux:
```commandline
docker run  -it tutorials_backend bash
```

[//]: # (or Windows:)
[//]: # (```commandline)
[//]: # (docker run -v %cd%/data:/demo -it dc_demo bash)
[//]: # (```)


## Tutorials

1. Occurrence data download
2. Occurrence data manipulation
3. SDM
4. PAM creation and analysis
5. Phylogenetic diversity with Tree and PAM
6. Biogeographic hypotheses and MCPA
7. Hypothesis testing
8. Scaling?


## Troubleshooting

To delete all containers, images, networks and volumes, stop any running
containers:

```zsh
docker compose stop
```

And run this command (which ignores running container):

```zsh
docker system prune --all --volumes
```

clean_occurrences --species_key species_name --x_key x --y_key y  --report_filename output/cleaning_report.json input/heuchera.csv  output/clean_heuchera.csv input/wrangler_conf.json
