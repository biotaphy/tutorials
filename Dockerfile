FROM osgeo/gdal:ubuntu-small-latest as backend

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y vim && \
    apt-get install -y python3-pip

# .....................................................................................
# Install biotaphy projects for system

# Remove when this has been added to lmpy requirements
RUN pip install requests

RUN mkdir git

# specify-lmpy from pypi
#RUN cd git &&  \
#    git clone https://github.com/specifysystems/lmpy.git &&  \
#    cd lmpy \
#    && pip install .
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

# .....................................................................................

# .....................................................................................
# Copy read-only inputs to volume
COPY ./data/input /volumes/data/input
COPY ./data/params /volumes/data/params

SHELL ["/bin/bash", "-c"]

