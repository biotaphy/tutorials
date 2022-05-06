FROM osgeo/gdal:ubuntu-small-latest as backend

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y vim && \
    apt-get install -y python3-pip

# .....................................................................................
# Install biotaphy projects for system

# Remove when this has been added to lmpy requirements
RUN pip install requests

# specify-lmpy
RUN mkdir git && \
    cd git && \
    git clone https://github.com/specifysystems/lmpy.git

RUN pip install specify-lmpy

#  BiotaphyPy
RUN cd git &&  \
    git clone https://github.com/biotaphy/BiotaPhyPy.git &&  \
    cd BiotaPhyPy \
    && pip install .

# lmtools
RUN cd git && \
    git clone https://github.com/specifysystems/lmtools.git && \
    cd lmtools && \
    pip install .

# Maxent
RUN cd git && \
    git clone https://github.com/mrmaxent/Maxent.git

ENV MAXENT_VERSION=3.4.4
ENV MAXENT_JAR=/git/Maxent/ArchivedReleases/$MAXENT_VERSION/maxent.jar

## .....................................................................................
## Add biotaphy user, group, home directory
#RUN addgroup --system --gid 888 biotaphy \
# && adduser --system  --gid 888 --uid 888 biotaphy
#
#RUN mkdir -p /home/biotaphy \
# && chown biotaphy.biotaphy /home/biotaphy
#
##COPY --chown=biotaphy:biotaphy ./data /home/biotaphy/
#
#RUN mkdir -p /scratch-path/log \
# && chown -R biotaphy.biotaphy /scratch-path
#

# .....................................................................................
# Copy static inputs to container
RUN mkdir -p /biotaphy_data
COPY ./data/input /biotaphy_data/input
COPY ./data/param_config /biotaphy_data/param_config


## Change user, workdir
#WORKDIR /home/biotaphy
#USER biotaphy

SHELL ["/bin/bash", "-c"]

