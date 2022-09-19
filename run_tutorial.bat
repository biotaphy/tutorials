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

:: -----------------------------------------------------------
:: Main
:: -----------------------------------------------------------

@echo off
setlocal EnableDelayedExpansion
set /A n=0
for %%a in (build_image  rebuild_data
            cleanup  cleanup_most  cleanup_all
            list_commands list_outputs  list_volumes
            wrangle_occurrences  split_occurrence_data
            wrangle_species_list  wrangle_tree
            create_sdm
            build_grid  encode_layers calculate_pam_stats
) do (
   set COMMANDS[!n!]=%%a
   set /A n+=1
)

set CMD=%1
set HOST_CONFIG_FILE=%2
set arg_count=0
for %%x in (%*) do set /A arg_count+=1
echo "arg_count = " %arg_count%

set command_path=/git/lmpy/lmpy/tools
echo %command_path%

call set_defaults
echo %IMAGE_NAME%
call time_stamp ":: Start"
echo ""

:: Arguments: none
if %arg_count% == 0 call usage


@REM :: Arguments: command
@REM elif [ $arg_count -eq 1 ]; then
@REM     if [ "%CMD%" == "cleanup" ] ; then
@REM         docker system prune -f --all
@REM         docker volume prune --filter "label!=saveme"
@REM     elif [ "%CMD%" == "cleanup_most" ] ; then
@REM         docker system prune -f --all
@REM         docker volume rm ${IN_VOLUME}
@REM         docker volume rm ${OUT_VOLUME}
@REM     elif [ "%CMD%" == "cleanup_all" ] ; then
@REM         docker system prune -f --all --volumes
@REM     elif [ "%CMD%" == "open" ] ; then
@REM         open_container_shell
@REM     elif [ "%CMD%" == "list_commands" ] ; then
@REM         usage
@REM     elif [ "%CMD%" == "list_outputs" ] ; then
@REM         list_output_volume_contents
@REM         start_container
@REM         remove_container
@REM     elif [ "%CMD%" == "list_volumes" ] ; then
@REM         list_all_volume_contents
@REM         start_container
@REM         remove_container
@REM     elif [ "%CMD%" == "build_image" ] || [ "%CMD%" == "rebuild_data" ] ; then
@REM         docker system prune -f --all
@REM         docker volume rm ${IN_VOLUME}
@REM         docker volume rm ${OUT_VOLUME}
@REM         echo "System build will take approximately 5 minutes ..." | tee -a "$LOG"
@REM         create_volumes
@REM         build_image_fill_data
@REM     elif [ "%CMD%" == "test" ]; then
@REM         list_output_volume_contents
@REM         remove_container
@REM         start_console
@REM         remove_container
@REM     else
@REM         usage
@REM     fi
@REM :: Arguments: command, config file
@REM else
@REM     if [[ " ${COMMANDS[*]} " =~  ${CMD}  ]]; then
@REM         create_volumes
@REM         build_image_fill_data
@REM         start_container
@REM         if [ "%CMD%" == "create_sdm" ] ; then
@REM             echo "Container python command:"  | tee -a "$LOG"
@REM             echo "   $command_path/%CMD%.py --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"
@REM             execute_python_process $command_path
@REM             echo "env vol ${VOLUME_MOUNT}/${ENV_VOLUME}:"
@REM             docker exec -it $CONTAINER_NAME ls -lahtr ${VOLUME_MOUNT}/${ENV_VOLUME}
@REM         else
@REM             echo "Container command: %CMD% --config_file=$CONTAINER_CONFIG_FILE" | tee -a "$LOG"
@REM             execute_process
@REM         fi
@REM         save_outputs
@REM ::        list_all_volume_contents
@REM ::        list_output_host_contents
@REM         remove_container
@REM     else
@REM         echo "Unrecognized command: %CMD%"
@REM         usage
@REM     fi
@REM fi

call time_stamp ":: End"
exit /b 0

:: -----------------------------------------------------------
:: Functions
:: -----------------------------------------------------------

:usage
    :: Commands that are substrings of other commands will match the superstring and
    :: possibly print the wrong Usage string.
    set n=0
    for %%a in (
                "wrangle_occurrences"  "split_occurrence_data"
                "wrangle_species_list"  "wrangle_tree"
                "create_sdm"
                "build_grid"  "encode_layers" "calculate_pam_stats"
    ) do (
        set config_required[!n!]=%%a
        set /a n+=1
    )

    echo
    echo Usage: %0% CMD
    echo "   or:  %0% CMD  parameters_file"
    echo ""
    echo "This script creates an environment for a biotaphy command to be run with "
    echo "user-configured arguments in a docker container."
    echo "the CMD argument can be one of:"
    for %%a in (%COMMANDS%) do (
        if defined config_required[%~1] (echo "      %%a   <parameters_file>" )
        else (echo "      %%a" )
    )
    echo "and the <parameters_file> argument must be the full path to a JSON file"
    echo "containing command-specific arguments"
    echo ""
exit /b 0

:: -----------------------------------------------------------
:set_defaults
    set IMAGE_NAME="tutor"
    set CONTAINER_NAME="tutor_container"
    set VOLUME_MOUNT="/volumes"
    set IN_VOLUME="data"
    set ENV_VOLUME="env"
    set OUT_VOLUME="output"
    set VOLUME_SAVE_LABEL="saveme"
    set VOLUME_DISCARD_LABEL="discard"

    :: Relative host config directory mapped to container config directory
    set VOLUME_MOUNT="/volumes"

    if [ ! -z "%HOST_CONFIG_FILE%" ] ; then
        if [ ! -f "%HOST_CONFIG_FILE%" ] ; then
            echo "File %HOST_CONFIG_FILE% does not exist"
            exit 0
        else
            SETLOCAL
            host_dir="%IN_VOLUME%/config"
            container_dir="%VOLUME_MOUNT%/%host_dir%"
            ENDLOCAL
            CONTAINER_CONFIG_FILE=$(echo %HOST_CONFIG_FILE% | sed "s:^$host_dir:$container_dir:g")
            echo "%CONTAINER_CONFIG_FILE%"
        fi
    fi

    set LOG=%CMD%.log
    if [ -f "%LOG%" ] ; then
        DEL "%LOG%"
    fi
    call time_stamp > "%LOG%"
exit /b 0

:: -----------------------------------------------------------
:time_stamp
    echo %1% %TIME% > "$LOG"
exit /b 0

