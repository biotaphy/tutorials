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
:: Script arguments
set SCRIPT_NAME=%0
set CMD=%1
set HOST_CONFIG_FILE=%2
set /a arg_count=0
for %%x in (%*) do set /a arg_count+=1
call:header arg_count = %arg_count%; SCRIPT_NAME = %SCRIPT_NAME%; CMD = %CMD%;  HOST_CONFIG_FILE = %HOST_CONFIG_FILE%

:: Logfile
SetLocal EnableExtensions
set LOG=%CMD%.log
if EXIST %LOG% (echo exists %LOG%)
echo Begin %TIME% > %LOG%
echo LOG = %LOG%

call:set_global_vars
call:time_stamp Defaults IMAGE_NAME, CONTAINER_NAME = %IMAGE_NAME%, %CONTAINER_NAME%

:: -----------------------------------------------------------
:: START TEST
:: -----------------------------------------------------------

call:time_stamp start test
call:check_host_config
call:create_volumes
call:time_stamp end test

:: -----------------------------------------------------------
:: END TEST
:: -----------------------------------------------------------

call:set_commands COMMANDS,COMMAND_COUNTER
call:header Set %COMMAND_COUNTER% elements of array; 0 and 15 are %COMMANDS[0]% and %COMMANDS[15]%

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
:check_host_config
    SetLocal EnableExtensions
    if Defined HOST_CONFIG_FILE (
        if Exist %HOST_CONFIG_FILE% (
            echo File %HOST_CONFIG_FILE% does exist
            ::set "%~1=0"
        ) else (
            echo File %HOST_CONFIG_FILE% does not exist
            ::set "%~1=2"
            call:usage
        )
    ) else (
        echo File %HOST_CONFIG_FILE% undefined
        :: Some commands do not require a config_file, so not always an error
        ::set "%~1=1"
    )
exit /b 0

:: -----------------------------------------------------------
:set_global_vars
    call:header set_global_vars
    set IMAGE_NAME=tutor
    set CONTAINER_NAME=tutor_container
    set VOLUME_MOUNT=/volumes
    set IN_VOLUME=data
    set ENV_VOLUME=env
    set OUT_VOLUME=output
    set VOLUME_SAVE_LABEL=saveme
    set VOLUME_DISCARD_LABEL=discard

    :: Get the fullpath to the config filename for Linux container
    echo stage1 HOST_CONFIG_FILE %HOST_CONFIG_FILE%
    set VOLUME_MOUNT=/volumes
    set CONTAINER_CONFIG_DIR=%VOLUME_MOUNT%/%IN_VOLUME%/config
    for %%i in ("%HOST_CONFIG_FILE%") do ( set filename=%%~nxi )
    echo filename %filename%
    set CONTAINER_CONFIG_FILE=%CONTAINER_CONFIG_DIR%/%filename%
    echo stage1 complete: CONTAINER_CONFIG_FILE %CONTAINER_CONFIG_FILE%
exit /b 0

:: -----------------------------------------------------------
:header
ECHO =================================================
ECHO %*
ECHO =================================================
ECHO ================================================= >> %LOG%
ECHO %* >> %LOG%
ECHO ================================================= >> %LOG%
EXIT /B 0

:: -----------------------------------------------------------
:time_stamp
    echo %TIME% %*
    echo %TIME% %* >> %LOG%
exit /b 0

:: -----------------------------------------------------------
:set_commands
    call:header set_commands
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
    call:time_stamp finished set_commands
exit /b 0

:: -----------------------------------------------------------
:create_volumes
    :: Create named RO input volumes for use by any container
    :: Small input data, part of repository
    call:header create_volumes
    set var=NAME
    ::for /f "tokens=3 usebackq" %%i in (`docker volume ls ^| find "%IN_VOLUME%"`) do
    for /f "tokens=3 usebackq" %%i in (`docker volume ls ^| find "%var%"`) do (
        set input_vol=%%i
    )
    echo input_vol is %input_vol%
    ::for /f "tokens=* usebackq" %%i in (`docker volume ls ^| find "%IN_VOLUME%"`) do
        ::set input_vol_exists!count!=%%i
        ::set /a count=!count!+1

exit /b 0

:: -----------------------------------------------------------
:build_image_fill_data
    call:header build_image_fill_data
exit /b 0

:: -----------------------------------------------------------
:start_container
    call:header start_container
exit /b 0

:: -----------------------------------------------------------
:wrangle_species_list
    call:header wrangle_species_list
exit /b 0
