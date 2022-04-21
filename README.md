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

3. Run the containers:

```zsh
docker compose up -d
```

Image tutorials_back-end is now available

[//]: # (### Development)
[//]: # ()
[//]: # (Run the containers:)
[//]: # (```zsh)
[//]: # (docker compose -f docker-compose.yml -f docker-compose.development.yml up)
[//]: # (```)

4. Run a bash shell in the container interactively

Mac / Linux:
```commandline
docker run  -it tutorials_back-end bash
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

To examine containers at a shell prompt: 

```zsh
docker exec -it tutorial /bin/sh
```
