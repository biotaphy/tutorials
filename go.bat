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
:: Init log first
set LOG=%CMD%.log
echo set LOG
if EXIST %LOG% (echo exists %LOG%) else (echo %LOG% does not exist)
echo Begin %TIME% > %LOG%
echo LOG = %LOG%

:: Script arguments
set SCRIPT_NAME=%0
set CMD=empty
set HOST_CONFIG_FILE=empty
set arg_count=0
for %%x in (%*) do set /a arg_count+=1
if %arg_count% gtr 0 ( set CMD=%1 )
if %arg_count% gtr 1 ( set HOST_CONFIG_FILE=%2 )
call:time_stamp arg_count is %arg_count%, SCRIPT_NAME is %SCRIPT_NAME%, CMD is %CMD%,  HOST_CONFIG_FILE is %HOST_CONFIG_FILE%

:: Set environment
SetLocal EnableExtensions
call:set_global_vars
call:set_commands COMMANDS,COMMAND_COUNTER
call:time_stamp Set %COMMAND_COUNTER% elements of array; 0 and 15 are %COMMANDS[0]% and %COMMANDS[15]%
call:time_stamp Defaults IMAGE_NAME, CONTAINER_NAME = %IMAGE_NAME%, %CONTAINER_NAME%

:: Error checking
call:check_host_config

:: Build docker container
call:create_volumes
call:build_image_fill_data

:: -----------------------------------------------------------
:: START TEST
:: -----------------------------------------------------------

call:time_stamp start test
call:start_container
::call:test_something
call:time_stamp end test

:: -----------------------------------------------------------
:: END TEST
:: -----------------------------------------------------------


call:time_stamp End
exit /b 0

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
    SetLocal EnableExtensions EnableDelayedExpansion
    call:header check_host_config
    if not Defined HOST_CONFIG_FILE goto :undef

    call:time_stamp File HOST_CONFIG_FILE defined
    if not exist %HOST_CONFIG_FILE% goto :missing

    :undef
    call:time_stamp File HOST_CONFIG_FILE not defined
    exit /b 0

    :missing
    call:time_stamp File %HOST_CONFIG_FILE% missing
    exit /b 1
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
    :: Option string for volumes
    set opt1=--volume %IN_VOLUME%:%VOLUME_MOUNT%/%IN_VOLUME%
    set opt2=--volume %ENV_VOLUME%:%VOLUME_MOUNT%/%ENV_VOLUME%
    set opt3=--volume %OUT_VOLUME%:%VOLUME_MOUNT%/%OUT_VOLUME%
    echo opts are %opt1% %opt2% %opt3%

    :: Get the fullpath to the config filename for Linux container
    echo stage1 HOST_CONFIG_FILE %HOST_CONFIG_FILE%
    set VOLUME_MOUNT=/volumes
    set CONTAINER_CONFIG_DIR=%VOLUME_MOUNT%/%IN_VOLUME%/config
    for %%i in ("%HOST_CONFIG_FILE%") do ( set filename=%%~nxi )
    echo filename %filename%
    set CONTAINER_CONFIG_FILE=%CONTAINER_CONFIG_DIR%/%filename%
    set CMD_PATH=/git/lmpy/lmpy/tools
    echo stage1 complete: CONTAINER_CONFIG_FILE %CONTAINER_CONFIG_FILE%
exit /b 0

:: -----------------------------------------------------------
:header
    echo =================================================
    echo %*
    echo =================================================
    echo ================================================= >> %LOG%
    echo %* >> %LOG%
    echo ================================================= >> %LOG%
exit /b 0

:: -----------------------------------------------------------
:time_stamp
    echo %TIME% %*
    ::echo %TIME% %* >> %LOG%
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
:test_something
    :: Create named input volumes for use by any container
    call:header test_something
    :: Small input data, part of repository
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%IN_VOLUME%"` ) do ( SET tmp=%%g )
    if %tmp% == %IN_VOLUME% (
        call:time_stamp - Volume %IN_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %IN_VOLUME%
    set tmp=empty
exit /b 0

:: -----------------------------------------------------------
:create_volumes
    :: Create named input volumes for use by any container
    call:header create_volumes
    :: Small input data, part of repository
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%IN_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %IN_VOLUME% (
        call:time_stamp - Volume %IN_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %IN_VOLUME%
        docker volume create --label=%VOLUME_DISCARD_LABEL% %IN_VOLUME%
    )
    :: Large environmental data
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%ENV_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %ENV_VOLUME% (
        call:time_stamp - Volume %ENV_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %ENV_VOLUME%
        docker volume create --label=%VOLUME_SAVE_LABEL% %ENV_VOLUME%
    )
    :: Output data for use by any container
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%OUT_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %OUT_VOLUME% (
        call:time_stamp - Volume %OUT_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %OUT_VOLUME%
        docker volume create --label=%VOLUME_SAVE_LABEL% %OUT_VOLUME%
    )
    set tmp=empty
exit /b 0

:: -----------------------------------------------------------
:build_image_fill_data
    :: Build and name an image from Dockerfile in this directory
    :: This build also populates the data and env volumes
    call:header build_image_fill_data
    for /f "tokens=1 usebackq" %%g in ( `docker image ls ^| find "%IMAGE_NAME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %IMAGE_NAME% (
        call:time_stamp - Image %IMAGE_NAME% exists
    ) else (
        call:time_stamp - Create image %IMAGE_NAME%
        docker build . -t %IMAGE_NAME%
    )
    set tmp=empty
exit /b 0

:: -----------------------------------------------------------
:start_container
    call:header start_container
    ::call:build_image_fill_data
    :: Find running container
    for /f "tokens=10 usebackq" %%g in ( `docker ps ^| find "%CONTAINER_NAME%"` ) do (
        SET tmp=%%g )
    call:time_stamp tmp container is %tmp%
    if %tmp% == %CONTAINER_NAME% (
        call:time_stamp - Container %CONTAINER_NAME% is running
    ) else (
        call:time_stamp - Start container %CONTAINER_NAME% from %IMAGE_NAME%
        call:build_image_fill_data
        :: Start the container, leaving it up
        docker run -td --name %CONTAINER_NAME%  %opt1% %opt2% %opt3%  %IMAGE_NAME%  bash
    )
    set tmp=empty
exit /b 0

:: -----------------------------------------------------------
:wrangle_species_list
    call:header wrangle_species_list
exit /b 0
