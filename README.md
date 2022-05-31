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

3. Run the bash script with a command and configuration file to:

   1. create the volumes `data` and `output` (if they do not exist)
   2. build the image `tutor` (if it does not exist)
   3. start a container `tutor_container` with volumes attached and
   4. run the chosen command with chosen configuration file
   5. compute output files in the `output` volume
   6. copy output files to the host machine

```zsh
./run_tutorial.sh wrangle_occurrences data/input/clean_occurrences.json
```

4. Run a bash shell in the container interactively to examine outputs

Mac / Linux:

```commandline
docker run  -it tutorials_backend bash
root@f13e704738cf:/# ls -lahtr /volumes/output/
total 72K
drwxr-xr-x 1 root root 4.0K May 25 15:41 ..
-rw-r--r-- 1 root root  56K May 25 15:58 resolve_list_names.log
-rw-r--r-- 1 root root   97 May 25 15:58 resolve_list_names.rpt
-rw-r--r-- 1 root root 2.4K May 25 15:58 heuchera_accepted.txt
drwxr-xr-x 2 root root 4.0K May 25 15:58 .
```

5. Check the output locally

```commandline
ls -lahtr ./output
astewart@murderbot:~/git/tutorials$ ls -lahtr ./output/
total 72K
-rw-r--r-- 1 astewart astewart   97 May 25 10:58 resolve_list_names.rpt
-rw-r--r-- 1 astewart astewart  56K May 25 10:58 resolve_list_names.log
-rw-r--r-- 1 astewart astewart 2.4K May 25 10:58 heuchera_accepted.txt
drwxr-xr-x 2 astewart astewart 4.0K May 25 10:58 .
drwxrwxr-x 9 astewart astewart 4.0K May 25 12:48 ..
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


## Run without helper script

Create volumes outside of Dockerfiles and compose files

```zsh
docker volume create data
docker volume create output
```

Build and name image:

```zsh
docker build . -t tutor
```

Run, attaching volumes, with command and (container) path to config file:

```zsh
CMD="wrangle_occurrences /volumes/data/input/clean_occurrences.json"
docker run -it --volume data:/volumes/data:ro --volume output:/volumes/output tutor $CMD
```
4.
5. Run a bash shell in the container interactively to examine outputs

Mac / Linux:

```commandline
docker run  -it tutorials_backend bash
root@f13e704738cf:/# ls -lahtr /volumes/output/
total 72K
drwxr-xr-x 1 root root 4.0K May 25 15:41 ..
-rw-r--r-- 1 root root  56K May 25 15:58 resolve_list_names.log
-rw-r--r-- 1 root root   97 May 25 15:58 resolve_list_names.rpt
-rw-r--r-- 1 root root 2.4K May 25 15:58 heuchera_accepted.txt
drwxr-xr-x 2 root root 4.0K May 25 15:58 .
```

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
