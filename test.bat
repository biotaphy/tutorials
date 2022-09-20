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
call:header arg_count = %arg_count%; SCRIPT_NAME = %SCRIPT_NAME%; CMD = %CMD%;  HOST_CONFIG_FILE = %HOST_CONFIG_FILE%
call:time_stamp

:: Arguments: none
if %arg_count% == 0 call:usage

call:set_defaults
call:header Defaults IMAGE_NAME, CONTAINER_NAME = %IMAGE_NAME%, %CONTAINER_NAME%

call:set_commands COMMANDS,COMMAND_COUNTER
call:header Set %COMMAND_COUNTER% elements of array: 0 and 15 are %COMMANDS[0]% and %COMMANDS[15]%

set command_path=/git/lmpy/lmpy/tools

call:time_stamp End
EXIT /B 0

:: -----------------------------------------------------------
:: Functions
:: -----------------------------------------------------------

:usage
    :: Commands that are substrings of other commands will match the superstring and
    :: possibly print the wrong Usage string.
    echo.
    echo Usage: %SCRIPT_NAME% cmd
    echo    or:  %SCRIPT_NAME% cmd  parameters_file
    echo.
    echo This %SCRIPT_NAME% script creates an environment for a BiotaPhy command to be run with
    echo user-configured arguments in a docker container.
    echo The `cmd` argument can be one of the following, without a parameter file
    echo     build_image
    echo     rebuild_data
    echo     cleanup
    echo     cleanup_most
    echo     cleanup_all
    echo     list_commands
    echo     list_outputs
    echo     list_volumes
    echo or one of the following commands requiring a parameters file:
    echo     wrangle_occurrences
    echo     split_occurrence_data
    echo     wrangle_species_list
    echo     wrangle_tree
    echo     create_sdm
    echo     build_grid
    echo     encode_layers
    echo     calculate_pam_stats
    echo.
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
    :: Linux forward slash path separator for container
    set VOLUME_MOUNT=/volumes
    set CONTAINER_CONFIG_DIR=%VOLUME_MOUNT%/%IN_VOLUME%/config
    :: Windows backslash path separator
    set HOST_CONFIG_DIR=%IN_VOLUME%\config

    SetLocal EnableExtensions EnableDelayedExpansion
    if Defined HOST_CONFIG_FILE (
        if Exist %HOST_CONFIG_FILE% (
            FOR %%i IN ("%HOST_CONFIG_FILE%") DO (
                set filename=%%~nxi
            )
            echo full name is %CONTAINER_CONFIG_DIR%/%filename%
            set CONTAINER_CONFIG_FILE=%CONTAINER_CONFIG_DIR%/%filename%
            ::CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$host_dir:$container_dir:g")
            echo container file returned as %CONTAINER_CONFIG_FILE%

        ) else (
            echo File %HOST_CONFIG_FILE% does not exist
        )
    ) else (
        echo File %HOST_CONFIG_FILE% undefined
    )
    :: Logfile
    set LOG=%CMD%.log
    if EXIST %LOG% DEL %LOG%
exit /b 0

:: -----------------------------------------------------------
:: Set 1st specified variable to a concatenated fully qualified drive\path name
:: from the 2nd and 3rd variables, with no redundant backslashes. Convert all
:: forward slashes to backslashes.  Removes quotes.
::set_fqdp
::set %1=%~f2
::exit /b %_ERROR_SUCCESS_%

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
    :: args: COMMANDS, COMMAND_COUNTER
    set %~1[0]=build_image
    set %~1[1]=rebuild_data
    set %~1[2]=cleanup
    set %~1[3]=cleanup_most
    set %~1[4]=cleanup_all
    set %~1[5]=list_commands
    set %~1[6]=list_outputs
    set %~1[7]=list_volumes
    set %~1[8]=wrangle_occurrences
    set %~1[9]=split_occurrence_data
    set %~1[10]=wrangle_species_list
    set %~1[11]=wrangle_tree
    set %~1[12]=create_sdm
    set %~1[13]=build_grid
    set %~1[14]=encode_layers
    set %~1[15]=calculate_pam_stats
    set /A %~2=15
    call:time_stamp finished set_commands3
exit /b 0

:: -----------------------------------------------------------
:: recreate this linux command
::      CONTAINER_CONFIG_FILE=$(echo $HOST_CONFIG_FILE | sed "s:^$host_dir:$container_dir:g")
:: arg1 = CONTAINER_CONFIG_FILE
:convert_filename
    SetLocal EnableDelayedExpansion
    FOR %%i IN ("%HOST_CONFIG_FILE%") DO (
        set filename=%%~nxi
        echo filename is %filename%
    )
    echo full name is %CONTAINER_CONFIG_DIR%/%filename%
    set %~1=%CONTAINER_CONFIG_DIR%/%filename%
    EndLocal
exit /b 0