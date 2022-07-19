FROM osgeo/gdal:ubuntu-small-latest as backend

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y vim && \
    apt-get install -y python3-pip && \
    apt-get install -y default-jdk

# .....................................................................................
# Install biotaphy projects for system

# Remove when this has been added to lmpy requirements
RUN pip install requests

RUN mkdir git

# specify-lmpy testing branch from Github
RUN cd git &&  \
    git clone -b tryout_sdm https://github.com/specifysystems/lmpy.git &&  \
    cd lmpy \
    && pip install .
# specify-lmpy from pypi
#RUN pip install specify-lmpy

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

# .....................................................................................

# .....................................................................................
# Populate (pre-created, read-only) volume with inputs
COPY ./data/input /volumes/data/input
COPY ./data/config /volumes/data/config
COPY ./data/wranglers /volumes/data/wranglers

SHELL ["/bin/bash", "-c"]
