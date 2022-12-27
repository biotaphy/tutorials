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

:: ------------------------------------------------------------------------------------
:: Main
:: ------------------------------------------------------------------------------------

@echo off
:: Script arguments
set SCRIPT_NAME=%0
set CMD=empty
set HOST_CONFIG_FILE=empty
set arg_count=0
for %%x in (%*) do set /a arg_count+=1

if %arg_count% gtr 0 ( set tmp_arg=%1 )
call :trim CMD %tmp_arg%
set tmp_arg=empty

if %arg_count% gtr 1 ( set tmp_arg=%2 )
call :trim HOST_CONFIG_FILE %tmp_arg%
echo arg_count is %arg_count%, SCRIPT_NAME is %SCRIPT_NAME%, CMD is %CMD%,  HOST_CONFIG_FILE is %HOST_CONFIG_FILE%

if %arg_count% equ 0 (
    call:usage
) else (
    call:init_log
    call:set_global_vars
    call:run_command
)

call:time_stamp End
exit /b 0

:: ------------------------------------------------------------------------------------
:: ------------------------------------------------------------------------------------

:: -----------------------------------------------------------
:: Functions
:: -----------------------------------------------------------
:: -----------------------------------------------------------
:run_command
    call:header run_command
    # Docker commands with no command-line parameters
    if %CMD% == cleanup ( call:cleanup )
    if %CMD% == cleanup_all ( call:cleanup_all )
    if %CMD% == open ( call:open_container_shell )
    if %CMD% == list_commands ( call:usage )
    if %CMD% == list_outputs ( call:list_output_volume_contents )
    if %CMD% == list_volumes ( call:list_all_volume_contents )
    if %CMD% == build_all ( call:build_all )
    :: Biotaphy tools needing config_file parameter
    if %CMD% == build_grid ( call:execute_process )
    if %CMD% == calculate_pam_stats ( call:execute_process )
    if %CMD% == rasterize_point_heatmap ( call:execute_process )
    if %CMD% == rasterize_site_stats ( call:execute_process )
    if %CMD% == convert_lmm_to_csv ( call:execute_process )
    if %CMD% == convert_lmm_to_geojson ( call:execute_process )
    if %CMD% == create_sdm ( call:execute_process )
    if %CMD% == encode_layers ( call:execute_process )
    if %CMD% == randomize_pam ( call:execute_process )
    if %CMD% == rasterize_point_heatmap ( call:execute_process )
    if %CMD% == rasterize_site_stats ( call:execute_process )
    if %CMD% == split_occurrence_data ( call:execute_process )
    if %CMD% == wrangle_matrix ( call:execute_process )
    if %CMD% == wrangle_occurrences ( call:execute_process )
    if %CMD% == wrangle_species_list ( call:execute_process )
    if %CMD% == wrangle_tree ( call:execute_process )
exit /b 0

:: -----------------------------------------------------------
:trim
    SetLocal EnableDelayedExpansion
    set Params=%*
    for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
exit /b 0

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
    echo     build_all
    echo     cleanup
    echo     cleanup_all
    echo     list_commands
    echo     list_outputs
    echo     list_volumes
    echo or one of the following commands requiring a parameters file:
    echo     wrangle_occurrences
    echo     split_occurrence_data
    echo     wrangle_matrix
    echo     wrangle_species_list
    echo     wrangle_tree
    echo     create_sdm
    echo     build_grid
    echo     encode_layers
    echo     calculate_pam_stats
    echo.
exit /b 0

:: -----------------------------------------------------------
:init_log
    set LOG=%CMD%.log
    echo logfile is %LOG%
    if EXIST %LOG% ( del %LOG% ) else ( echo Create new %LOG% )
    echo Begin %TIME% > %LOG%
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
    set CONTAINER_CONFIG_DIR=%VOLUME_MOUNT%/%IN_VOLUME%/config
    :: Option string for volumes
    set opt1=--volume %IN_VOLUME%:%VOLUME_MOUNT%/%IN_VOLUME%
    set opt2=--volume %ENV_VOLUME%:%VOLUME_MOUNT%/%ENV_VOLUME%
    set opt3=--volume %OUT_VOLUME%:%VOLUME_MOUNT%/%OUT_VOLUME%

    set CMD_PATH=/git/lmpy/lmpy/tools
exit /b 0

:: -----------------------------------------------------------
:header
    set tmp=empty
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
    echo %TIME% %* >> %LOG%
exit /b 0

:: -----------------------------------------------------------
:build_image_fill_data
    :: Build and name an image from Dockerfile in this directory
    :: This build also populates the data and env volumes
    call:header build_image_fill_data
    call:create_volumes
    set tmp=empty
    for /f "tokens=1 usebackq" %%g in ( `docker image ls ^| find "%IMAGE_NAME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %IMAGE_NAME% (
        call:time_stamp - Image %IMAGE_NAME% exists
    ) else (
        call:time_stamp - Create image %IMAGE_NAME%
        docker build . -t %IMAGE_NAME%
    )
exit /b 0

:: -----------------------------------------------------------
:create_volumes
    :: Create named input volumes for use by any container
    :: Small input data, part of repository
    call:header create_volumes
    set tmp=empty
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%IN_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %IN_VOLUME% (
        call:time_stamp - Volume %IN_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %IN_VOLUME%
        docker volume create --label=%VOLUME_DISCARD_LABEL% %IN_VOLUME%
    )
    :: Large environmental data
    set tmp=empty
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%ENV_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %ENV_VOLUME% (
        call:time_stamp - Volume %ENV_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %ENV_VOLUME%
        docker volume create --label=%VOLUME_SAVE_LABEL% %ENV_VOLUME%
    )
    :: Output data for use by any container
    set tmp=empty
    for /f "tokens=2 usebackq" %%g in ( `docker volume ls ^| find "%OUT_VOLUME%"` ) do (
        SET tmp=%%g )
    if %tmp% == %OUT_VOLUME% (
        call:time_stamp - Volume %OUT_VOLUME% exists
    ) else (
        call:time_stamp - Create volume %OUT_VOLUME%
        docker volume create --label=%VOLUME_DISCARD_LABEL% %OUT_VOLUME%
    )
exit /b 0

:: -----------------------------------------------------------
:start_container
    call:header start_container
    :: If needed, create volumes, image, fill data
    call:build_image_fill_data
    :: Find running container
    set tmp=empty
    for /f "tokens=1 usebackq" %%g in ( `docker ps ^| find "%CONTAINER_NAME%"` ) do (
        SET tmp=%%g )
    if %tmp% == empty (
        call:time_stamp - Start container %CONTAINER_NAME% from %IMAGE_NAME%
        docker run -td --name %CONTAINER_NAME%  %opt1% %opt2% %opt3%  %IMAGE_NAME%  bash
    ) else (
        call:time_stamp - Container %CONTAINER_NAME% is running
    )
exit /b 0


:: -----------------------------------------------------------
:remove_container
    :: Find container, running or stopped
    call:header remove_container
    call:time_stamp - Stop container %CONTAINER_NAME%
    docker stop %CONTAINER_NAME%
    call:time_stamp - Remove container %CONTAINER_NAME%
    docker container rm %CONTAINER_NAME%
exit /b 0

:: -----------------------------------------------------------
:cleanup
    call:header cleanup
    docker system prune --force --all
    docker volume prune --filter "label=discard"
exit /b 0

:: -----------------------------------------------------------
:refresh
    call:header refresh
    call:remove_container
    docker volume rm %IN_VOLUME%
    docker volume rm %ENV_VOLUME%
    docker volume rm %OUT_VOLUME%
exit /b 0

:: -----------------------------------------------------------
:cleanup_all
    call:header cleanup_all
    docker system prune --force --all --volumes
exit /b 0

:: -----------------------------------------------------------
:list_output_volume_contents
    :: Find an image, start it with output volume, check contents
    call:header list_output_volume_contents
    call:start_container
    call:time_stamp  - List output volume contents %CONTAINER_NAME%
    docker exec -it %CONTAINER_NAME% ls -lahtr %VOLUME_MOUNT%/%OUT_VOLUME%
exit /b 0

:: -----------------------------------------------------------
:list_all_volume_contents
    call:header list_all_volume_contents
    :: Find an image, start it with output volume, check contents
    call:start_container
    call:time_stamp - List volume contents %CONTAINER_NAME%
    docker exec -it %CONTAINER_NAME% ls -lahtr %VOLUME_MOUNT%
    call:time_stamp    - Volume %ENV_VOLUME%
    docker exec -it %CONTAINER_NAME% ls -lahtr %VOLUME_MOUNT%/%ENV_VOLUME%
    call:time_stamp    - Volume %IN_VOLUME%
    docker exec -it %CONTAINER_NAME% ls -lahtr %VOLUME_MOUNT%/%IN_VOLUME%
    call:time_stamp    - Volume %OUT_VOLUME%
    docker exec -it %CONTAINER_NAME% ls -lahtr %VOLUME_MOUNT%/%OUT_VOLUME%
exit /b 0

:: -----------------------------------------------------------
:build_all
    call:header build_all
    call:cleanup_all
    call:header System build will take approximately 5 minutes ...
    call:build_image_fill_data
exit /b 0

:: -----------------------------------------------------------
:open_container_shell
    :: Find an image, start it with output volume, check contents
    call:header open_container_shell
    call:start_container
    call:time_stamp - Connect to %CONTAINER_NAME%
    docker exec -it %CONTAINER_NAME% bash
exit /b 0

:: -----------------------------------------------------------
:run_biotaphy
    call:header run_biotaphy
    echo HOST_CONFIG_FILE is %HOST_CONFIG_FILE%
    SetLocal EnableDelayedExpansion
        for %%i in ("!HOST_CONFIG_FILE!") do ( set filename=%%~nxi )
    echo filename is %filename% or !filename!
    set CONTAINER_CONFIG_FILE=%VOLUME_MOUNT%/%IN_VOLUME%/config/!filename!
    echo CONTAINER_CONFIG_FILE is %CONTAINER_CONFIG_FILE% or !CONTAINER_CONFIG_FILE!

    :: Command to execute in container
    call:time_stamp - Execute on container %CONTAINER_NAME% %CMD% --config_file=%CONTAINER_CONFIG_FILE%
    :: Run the command in the container
    if %CMD% == create_sdm (
        echo Docker command is python3 %CMD_PATH%/%CMD%.py --config_file=%CONTAINER_CONFIG_FILE%
        docker exec -it %CONTAINER_NAME% python3 %CMD_PATH%/%CMD%.py --config_file=%CONTAINER_CONFIG_FILE%
    ) else (
        echo Docker command is %CMD% --config_file=%CONTAINER_CONFIG_FILE%
        docker exec -it %CONTAINER_NAME% %CMD% --config_file=%CONTAINER_CONFIG_FILE%
    )
    EndLocal
exit /b 0

:: -----------------------------------------------------------
:execute_process
    call:header execute_process %CMD%
    if %HOST_CONFIG_FILE% == empty (
        call:time_stamp File HOST_CONFIG_FILE not defined
    ) else (
        if not exist %HOST_CONFIG_FILE% (
            call:time_stamp File %HOST_CONFIG_FILE% missing
        ) else (
            call:start_container
            :: Run the command in the container
            call:run_biotaphy
            call:time_stamp - Completed %CMD% execution on container
        )
        call:save_outputs
        call:remove_container
        call:time_stamp - Completed execute_process
    )
exit /b 0

:: -----------------------------------------------------------
:save_outputs
    call:header save_outputs
    :: TODO: determine if bind-mount is more efficient than this named-volume
    call:start_container
    :: Copy container output directory to host (no wildcards)
    :: If directory does not exist, create, then add contents
    call:time_stamp - Copy outputs from %OUT_VOLUME% to %IN_VOLUME%
    docker cp %CONTAINER_NAME%:%VOLUME_MOUNT%/%OUT_VOLUME%  ./%IN_VOLUME%/
exit /b 0

:: -----------------------------------------------------------
:remove_container
    call:header remove_container
    call:time_stamp - Stop container %CONTAINER_NAME%
    docker stop %CONTAINER_NAME%
    call:time_stamp - Remove container %CONTAINER_NAME%
    docker container rm %CONTAINER_NAME%
exit /b 0

:: -----------------------------------------------------------
:test
    call:header test
exit /b 0
