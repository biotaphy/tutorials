==================================
User Data and Parameters
==================================

--------------------------------
Introduction
--------------------------------

The BiotaPhy tutorials repository provides a template and structure that make it simple
to run any BiotaPhy tool with your own data and configuration.  The data and
configuration files are organized into standard locations, and the
`Script parameters file <../tutorial/script_params.rst>`_ aka `The File that Rules them All`,
names the input data, configuration files, and other parameters for a command.

--------------------------------
Overview
--------------------------------

This tutorials repository may be placed anywhere on your local system where you have
read/write permission.  The tutorials repository should be cloned using the `git`
command at the command line:

.. code-block::

   git clone https://github.com/biotaphy/tutorials

For more information about setting up your environment, see
`Webinar 1: Tutorial Overview <../tutorial/w1_overview.rst>`_.

Cloning the repository places the contents of the repository in the directory of your
choosing.  The top level directory of the repository is called `tutorials`.

All user-created data and configuration files should be placed in one of four
subdirectories, `config`, `env`, `input`, `wranglers`, of the `tutorials/data` directory,
described below.

--------------------------------
Primary script: run_tutorial
--------------------------------

The `run_tutorial` script is in the top-level `tutorials` directory
and has 2 versions: `run_tutorial.bat` is intended for Windows, and `run_tutorial.sh`
runs on Linux and MacOSX.

The `run_tutorial` script initiates Docker processes to support the BiotaPhy tools,
primarily running commands with user-input contained in a
configuration file, from the local computer operating system.  The `run_tutorial` script
also runs other housekeeping commands related to BiotaPhy Docker images, containers,
and volumes; these are primarily used for resetting after code modification, and
debugging.

--------------------------------
File sharing: user inputs
--------------------------------

Four directories under `/tutorials/data`: `env`, `input`, `config`, and `wranglers`,
will be copied to the Docker volume `data`, then made available to the Docker container
in the directory `/volumes/data`.  All files and subdirectories under these directories
will be copied to the `data` volume and be available to the Docker container.

tutorials/data/config
^^^^^^^^^^^^^^^^^^^^^^

`Script parameters files <../tutorial/script_params.rst>`_  are to be placed in the
`tutorials/data/config` directory.  These configuration files are used as the second
argument to `run_tutorial` BiotaPhy commands, for example

.. code-block::

   run_tutorial.sh <biotaphy_command>  <data/config/<script_param_file>

When calling a BiotaPhy command through the `run_tutorial` script, the script parameter
file argument must have the path to the file on the local filesystem.

Because the BiotaPhy command will be run **inside** the Docker container, the
file parameters within this file will point to the location in the volume, for example,
input data files will be in the path `/volumes/data/input/`.

tutorials/data/env
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Environmental data are to be placed under the `tutorials/data/env` directory.  Files and
subdirectories under this directory are available inside the Docker container through
the `/volumes/env` directory.  Any environmental data or directories specified in the
Script parameters file (parameter `env_dir` for the `create_sdm` command), should point
to the Docker container location.

tutorials/data/input
^^^^^^^^^^^^^^^^^^^^^^

Input data are to be placed in the `tutorials/data/input` directory.  Input data will be
available inside the Docker container through the `/volumes/data/input` directory.  Any
input data specified in the Script parameters file, should point to the Docker container
location.

tutorials/data/wranglers
^^^^^^^^^^^^^^^^^^^^^^

Wrangler files are to be placed in the `tutorials/data/wranglers` directory.  Wrangler files
will be available inside the Docker container through the `/volumes/data/wranglers`
directory. Any wranglers specified in the Script parameters file, should point to the
Docker container location.

--------------------------------
File sharing: output data
--------------------------------

Output files specified in the `Script parameters file <../tutorial/script_params.rst>`_, such as
`report_filename`, `log_filename`, `writer_filename`, should point to the
Docker container `/volumes/output` directory.  The `output` Docker volume is created and
made available to the Docker container in this directory. Upon command completion,
the contents of this directory are copied back to the local computer file system, in the
`tutorials/data/output` directory.

--------------------------------
Example pre-computed output
--------------------------------

The `tutorials/data/easy_bake` directory is simply a placeholder for example outputs for
the webinar series.  Data under this directory are **not** available to the Docker
container.
