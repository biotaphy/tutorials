============================
Biotaphy Tutorial Glossary
============================

.. glossary::

  Algorithm
    An algorithm is a procedure or formula for solving a problem.  There are  multiple
    algorithms for computing Species Distribution Models (SDM) which
    define the relationship between a set of points and the environmental values
    at those points.

  Biogeographic Hypotheses
    Spatial layers for testing the influence of geographic elements, such as
    geology, drainage basins, etc, on the biodiversity of a landscape. These
    can be in the form of raster or vector files.

  Container
    A :term:`Docker` instance which runs as an application on a :term:`Host machine`.
    The Docker container contains all software dependencies required by the programs it
    will run.

  CSV
    CSV (Comma Separated Values) is a file format for records, in which fields are
    separated by a delimiter.  Commas and tabs are common, but other characters may
    be used as delimiters.

  Docker
    Docker is an application which can run on Linux, MacOSX, or Windows.  With a
    Docker-ized application, such as this tutorial, a user can run the application on
    their local machine in a controlled and sequestered environment, with a set of
    dependencies that may not be easy, allowed, or even available for their local
    machine.

  Docker image
    A Docker-ized application, built into a single package, with all required
    software dependencies and files.

  DwCA
    DwCA (Darwin Core Archive) is a packaged dataset of occurrence records in `Darwin
    Core standard <https://www.tdwg.org/standards/dwc/>`_ format, along with metadata
    about the contents.

  JSON
    JSON (pronounced "jason") is a structured file format containing groups of keys
    with values, all enclosed in curly braces ( {} ).  Values may be basic data types
    like strings (enclosed in double-quotes, ""), numbers (not quoted), booleans
    (true or false, in lowercase and not quoted) or other literals.  Values may also be
    arrays (comma-delimited lists of basic data types, enclosed in square brackets, []),
    or another (nested) group of keys with values.  More information about JSON is
    `here <https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON>`_ and
    you can check your format with an online `validator <https://jsonlint.com/>`_.

  Data Wrangler
    Data wranglers are types of specify-lmpy data modification tools for filtering or
    editing data using specified criteria or methods.

  Environmental Layer
    Raster data representing environmental values for cells in a map.  Data
    may be numeric or categorical, with only one value per cell.
    Public data in BiotaPhy installations are in the 'Geographic' spatial
    reference system, latitude and longitude in decimal degrees.

  Geospatial data
    Geospatial data are data with geographic location associated with it, i.e. map
    data.  There are two kinds of spatial data, raster data and vector data.  Each
    has properties that make it better for representing different information.
    Geospatial data are discussed in more detail on the
    `Geospatial Data Terms <spatial_data>`_ page.

  Host machine
    The local physical machine on which the user will run Docker.

  Matrix
    A Matrix is a multi-dimensional array of values.

  MCPA
    Meta-Community Phylogenetic Analysis (MCPA, Leibold et al, 2010) is a "method that
    aims to evaluate the interaction between phylogenetic structure, historical
    biogeographic events and environmental filtering in driving species distributions in
    a large-scale metacommunity".

  PAM
    A Presence-Absence Matrix (PAM) is a 2-dimensional, binary Matrix of sites (rows)
    and species (columns).  The matrix contains species distributions of 0 and 1
    indicating presence or non-presence (absence) in each grid cell of a region. The
    matrix may be thought of as a three-dimensional cube of binary maps, with one
    layer per species.  The 3-dimensional matrix is flattened into 2 dimensions, with
    rows representing sites with an x,y coordinate for the center of a gridcell on a
    map, and columns representing species.

  Occurrence
    An occurrence is a record of a specimen occurrence including metadata about the
    specimen and the spatial location where it was found.

  Occurrence Data
    Point data representing specimens collected for a single species or taxon.  Each
    data point
    contains a location, x and y, in some known geographic spatial reference system.
    Public data in BiotaPhy installations are in the 'Geographic' spatial
    reference system, latitude and longitude in decimal degrees.

  Grid
    A grid (in this context) is a geospatial region represented as a contiguous set of
    square polygons (cells) to be used for matrix creation.  Grids are created as
    vector data, with one square polygon for every grid-cell, and stored in shapefile
    format.

  Phylogenetic Tree
    A Phylogenetic :term:`Tree` contains species names or identifiers for  analyzing
    evolutionary patterns.  BiotaPhy uses phylogenetic trees matching species
    data in a :term:`PAM` to correlate evolutionary patterns with species
    distributions and landscape features. Trees are stored in
    `Newick <https://evolution.genetics.washington.edu/phylip/newicktree.html>`_ or
    `Nexus <http://wiki.christophchamp.com/index.php?title=NEXUS_file_format>`_ format.

  SDM
    Species Distribution Modeling (SDM) is also known by several other names, including
    environmental niche modeling, ecological niche modeling, and habitat modeling.
    SDM refers to the process of creating mathematical formulas (models) to predict the
    geographic distribution of species based on where they have been found and the
    environmental conditions in those locations.

  Species Distribution Model
    A species distribution model (SDM) is an estimation of potential habitat for a
    particular species.

  Tree
    A Tree is a set of hierarchical data.

  Ultrametric Tree
    A :term:`Phylogenetic Tree` may contain numbers on the edges between species nodes
    corresponding to the hypothesized time between the evolution of one species node to
    the other.  In an Ultrametric tree, the branch length from each tip in
    the tree up to the root, is equal to all other tip-to-root total lengths.

  Docker volume
    Docker volumes are file systems mounted on a Docker :term:`Container` to share data
    from the :term:`Host machine` or preserve data generated by the running
    :term:`Container`. The volumes are stored on the host, independent of the container
    life cycle allowing users to back up or share file systems between containers.
