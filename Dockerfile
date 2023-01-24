FROM osgeo/gdal:ubuntu-small-latest as backend

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y vim && \
    apt-get install -y python3-rtree && \
    apt-get install -y python3-pip && \
    apt-get install -y default-jdk

# .....................................................................................
# Install biotaphy projects for system

# Remove when this has been added to lmpy requirements
RUN pip install requests

RUN mkdir git

# specify-lmpy testing branch from Github
RUN cd git &&  \
    git clone https://github.com/specifysystems/lmpy.git &&  \
    cd lmpy \
    && pip install .
# specify-lmpy from pypi
#RUN pip install specify-lmpy

#  BiotaphyPy
RUN cd git &&  \
    git clone https://github.com/biotaphy/BiotaPhyPy.git &&  \
    cd BiotaPhyPy \
    && pip install .

# Maxent
RUN cd git && \
    git clone https://github.com/mrmaxent/Maxent.git

ENV MAXENT_VERSION=3.4.4
ENV MAXENT_JAR=/git/Maxent/ArchivedReleases/$MAXENT_VERSION/maxent.jar

# .....................................................................................

# .....................................................................................
# Populate volumes with inputs
COPY ./data/input     /volumes/data/input
COPY ./data/config    /volumes/data/config
COPY ./data/wranglers /volumes/data/wranglers
# Populate big data volume with global 5 minute data
COPY ./data/env/biotaphy_5min_global  /volumes/env/biotaphy_5min_global
COPY ./data/env/ecoreg_5min_global.tif /volumes/env/ecoreg_5min_global.tif


