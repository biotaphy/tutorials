The ./docker directory contains a supplemental docker-compose file which sets 
environment variables in a `.env ` file, then calls a command using those variables from
within the docker container.  The initiating script (run_tutorial.sh or 
run_tutorial.bat) is called with the chosen command and a JSON file of command parameter 
names and arguments. 
