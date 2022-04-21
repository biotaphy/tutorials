#FROM conda/miniconda3:latest as back-end
#
#RUN conda update -n base -c conda-forge conda
#RUN conda install -y -c conda-forge tiledb=2.2.9 gdal libspatialindex rtree git openjdk=8

FROM osgeo/gdal:latest as backend

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y python3-pip

# .....................................................................................
# Install biotaphy projects
# specify-lmpy
# Remove when this has been added to lmpy requirements
RUN pip install requests
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

SHELL ["/bin/bash", "-c"]

