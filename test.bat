@echo OFF

::
:: This script calls docker commands to create an image, volumes, start a container from
:: the image, execute commands in that container, then copy outputs to the local
:: filesystem.
::
:: Note: this script uses a provided config file to
::   1. create the volumes `data` and `output` (if they do not exist)
::   2. build the image `tutor` (if it does not exist)
::   3. start a container with volumes attached and
::   4. run the chosen command with chosen configuration file
::   5. compute output files in the `output` volume
::   6. copy output files to the host machine

:: -----------------------------------------------------------
:: Main
:: -----------------------------------------------------------

@echo off

set SCRIPT_NAME=%0
set CMD=%1
set HOST_CONFIG_FILE=%2
set /a arg_count=0
for %%x in (%*) do Set /A arg_count+=1
echo arg_count =  %arg_count%

:: Arguments: none
if %arg_count% == 0 call:usage

call:header SCRIPT_NAME, CMD, HOST_CONFIG_FILE = %SCRIPT_NAME%, %CMD%, %HOST_CONFIG_FILE%
call:set_defaults
call:time_stamp Start with LOG = %LOG%

call:set_commands
for /l %%n in (0,1,16) do (
    echo !COMMANDS[%%n]!
)
call:set_commands2
for /l %%n in (0,1,16) do (
    echo !COMMANDS2[%%n]!
)

set command_path=/git/lmpy/lmpy/tools
echo command_path = %command_path%


call:time_stamp End
EXIT /B 0

:: -----------------------------------------------------------
:: Functions
:: -----------------------------------------------------------

:usage
    :: Commands that are substrings of other commands will match the superstring and
    :: possibly print the wrong Usage string.
    set n=0

    echo
    echo Usage: %SCRIPT_NAME% cmd
    echo    or:  %SCRIPT_NAME% cmd  parameters_file
    echo
    echo This script creates an environment for a biotaphy command to be run with
    echo user-configured arguments in a docker container.
    echo the `cmd` argument can be one of:

exit /b 0

:: -----------------------------------------------------------
:set_defaults
    set IMAGE_NAME=tutor
    set CONTAINER_NAME=tutor_container
    set VOLUME_MOUNT=/volumes
    set IN_VOLUME=data
    set ENV_VOLUME=env
    set OUT_VOLUME=output
    set VOLUME_SAVE_LABEL=saveme
    set VOLUME_DISCARD_LABEL=discard

    :: Relative host config directory mapped to container config directory
    set VOLUME_MOUNT=/volumes

    set LOG=%CMD%.log
    echo LOGFILE is %LOG%
    if EXIST %LOG% DEL %LOG%
exit /b 0

:: -----------------------------------------------------------
:header
ECHO =================================================
ECHO %*
ECHO =================================================
EXIT /B 0

:: -----------------------------------------------------------
:time_stamp
    echo %TIME% %*
    echo %TIME% %* > %LOG%
exit /b 0

:: -----------------------------------------------------------
:set_commands
    ::SetLocal EnableDelayedExpansion
    set COMMANDS=(build_image  rebuild_data
            cleanup  cleanup_most  cleanup_all
            list_commands list_outputs  list_volumes
            wrangle_occurrences  split_occurrence_data
            wrangle_species_list  wrangle_tree
            create_sdm
            build_grid  encode_layers calculate_pam_stats)
    set COMMANDS[0]=build_image
    set COMMANDS[1]=rebuild_data
    set COMMANDS[2]=cleanup
    set COMMANDS[3]=cleanup_most
    set COMMANDS[4]=cleanup_all
    set COMMANDS[5]=list_commands
    set COMMANDS[6]=list_outputs
    set COMMANDS[7]=list_volumes
    set COMMANDS[8]=wrangle_occurrences
    set COMMANDS[9]=split_occurrence_data
    set COMMANDS[10]=wrangle_species_list
    set COMMANDS[11]=wrangle_tree
    set COMMANDS[12]=create_sdm
    set COMMANDS[13]=build_grid
    set COMMANDS[14]=encode_layers
    set COMMANDS[15]=calculate_pam_stats
    set /A COMMAND_COUNT=16
    call:time_stamp Set each of %COMMAND_COUNT% commands
    for /l %%n in (0,1,16) do (
        echo !COMMANDS[%%n]!
    )

    call:time_stamp finished set_commands
exit /b 0

:set_commands2
    SetLocal EnableDelayedExpansion
    set /A n=0
    for %aa in (build_image rebuild_data cleanup cleanup_most cleanup_all
        list_commands list_outputs list_volumes wrangle_occurrences
        split_occurrence_data wrangle_species_list wrangle_tree create_sdm
        build_grid  encode_layers calculate_pam_stats)
    do (
        set COMMANDS2[!n!]=%%a
        set /A n+=1
    )
    COMMAND_COUNT2=n
    call:time_stamp Set with list %COMMAND_COUNT2% commands
    for /l %%n in (0,1,%COMMAND_COUNT2%) do (
        echo !COMMANDS2[%%n]!
    )

    call:time_stamp finished set_commands
exit /b 0

