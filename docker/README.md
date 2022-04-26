The ./docker contains tutorial-specific directories, each with a supplemental docker-compose file which calls the 
appropriate command from within the docker container.  The initiating script (go.sh or go.bat) is called with the chosen
command and an INI file.  This script creates a docker .env file, populating it with environment variables to be used 
with the "command" directive in the command-specific docker-compose file.
