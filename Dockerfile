# .....................................................................................
# Conda base
#  Base image for installing packages with Conda
FROM conda/miniconda3:latest as conda_base

RUN conda update -n base -c conda-forge conda
# Install conda-pack for shrinking images
# RUN conda install -c conda-forge conda-pack


# .....................................................................................
# Biotaphy Tutorial
#   Container for performing Biotaphy computations for webinars and tutorials

FROM conda_base as biotaphy_tutorial

RUN conda update -n base -c conda-forge conda && \
    conda install -y -c conda-forge tiledb=2.2.9 gdal libspatialindex rtree git openjdk=8

ENV PROJ_LIB=/usr/local/share/proj/

RUN pip install specify-lmpy

# Install BiotaPhyPy
RUN mkdir git && \
    cd git && \
	git clone https://github.com/biotaphy/BiotaPhyPy.git && \
	cd BiotaPhyPy && \
	pip install .

# Install lmtools
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
