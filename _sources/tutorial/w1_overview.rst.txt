==============================
Webinar 1: Tutorial Overview
==============================

--------------------------------
Introduction
--------------------------------

These tutorials step through the process of running a Biotaphy tool (or command) with
example data.  There are several entry points to the tools.  These tutorials cover
running them through a command line script, which creates a Docker container, installs
the tools, executes the processes, and returns the outputs to the local machine.

--------------------------------
Preparation
--------------------------------
All commands will be typed at a command prompt. In Linux or OSX, open a Terminal
window.  In Windows, go to the Start menu, and type **command** in the Search bar.  Open
the Command Prompt application that appears.

Download the github repository for this tutorial, including scripts, data, and
configuration files.

Type `git` at the command prompt to see if you have git installed.  If you do not,
download and install git from https://git-scm.com/downloads .

Download the Biotaphy tutorial by typing at the command line:

.. code-block::

   git clone https://github.com/biotaphy/tutorials

To run Biotaphy tools on any OS, locally through :term:`Docker`, first download and
install `Docker <https://docs.docker.com/get-started/>`_.

--------------------------------------------------
Host and Container input, output, log directories
--------------------------------------------------

A data Docker :term:`Volume`, is created on the :term:`Host machine`, and the
tutorials/data/input, tutorials/data/config, and tutorials/data/wranglers directories
in this repository are copied to it.  These directories are then made available on the
Docker :term:`Container` under the /volumes/data volume (directory).
If modified, the docker "data" volume must be re-created to propagate those changes to
the containers.

Another Docker volume, `output`, is created on the :term:`Host machine` and mounted at
/volumes/output in the Docker :term:`Container`.  Changes in this directory are saved
in the volume, and copied back to the host machine, under the data directory.

-------------------------------------------
Data preparation: Script parameters File
-------------------------------------------

All commands require a parameters file with tool-specific parameters.  The file
must be in :term:`JSON` format.  More information is in the `Script parameters file
<script_params>`_ documentation.

Each tutorial contains one or more example parameters files in the
tutorials/data/config directory.  These parameters files reference example data and
parameters reasonable for that command.  All required and optional parameters are
described in individual tutorial pages.

Some tools will require an additional :term:`JSON` format configuration file.  In these
cases, the additional JSON file will be named in the parameters file.

-------------------------------------------
Docker preparation
-------------------------------------------

Start Docker if it is not running. On Mac and Windows, start the Docker application.
On Linux, check with

.. code-block::

   systemctl status docker

and if it is not running, run

.. code-block::

   systemctl start docker

We can jump-start the process by building the volumes and image in a separate step.
This step will take some time, approximately 5-7 minutes, depending on your local
computer hardware and active software.

.. code-block::

   ./run_tutorial.sh build_all

-------------------------------------------
Run tool tutorials
-------------------------------------------


The "run_tutorial" script will run each tutorial with two arguments,
the 1) command name and 2) parameters file.  The parameters file will be a path
on the local machine, in the tutorials/data/config directory.  The script will translate
that to the container path, and execute the command in the container with the
container's copy of the file.  For example, the
`wrangle_species_list <w2_resolve_splist_names>`_ tutorial can be initiated
with:

.. code-block::

   ./run_tutorial.sh wrangle_species_list ./data/config/wrangle_species_list_gbif.json


-------------------------------------------
Behind the scenes
-------------------------------------------

The "run_tutorial" script will execute the following functions, unless their outputs
have already been created:

1. Create several :term:`Docker Volumes<Volume>` to share data between the host and
   Docker container.
2. Build a :term:`Docker image`.
3. Start a Docker :term:`Container` from the image, with volumes attached.  A
   Container is similar to a fully functioning computer with data and applications.
4. Execute the specified command with the parameters in the specified configuration
   file.  The process will execute using a parameter file and data in the `data`
   :term:`data volume<Volume>` and write outputs to the :term:`output volume<Volume>`,
   executing code in the :term:`Docker container<Container>`.
5. Copy the container **/volumes/output** directory back to the local data directory.
6. Stop and delete the container.  All outputs in the docker volume are preserved and
   accessible the next time it is attached to a container.

-------------------------------------------
Outputs
-------------------------------------------

All outputs are specified in the Tool Configuration File provided to the command, and
will be copied to the data/outputs directory on completion.

-------------------------------------------
Summary of tutorial commands
-------------------------------------------

Tools can be called with the run_tutorial script:

.. code-block::

       ./run_tutorial.sh  <command>  <tool_configuration_file>

Sending the command **list_commands** will print all valid commands.  All Biotaphy
commands require an additional parameter configuration file.
