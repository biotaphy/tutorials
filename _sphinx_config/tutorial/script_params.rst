============================
Script parameters file
============================

A :term:`JSON` parameter file is required for all tutorial commands.  There are one or
more example parameter files for each tutorial.  All of these JSON parameter files
follow the same pattern, and many have the same options.

1. Each command has required and/or optional parameters.
2. The group of options are enclosed in curly braces ( {} ).
3. Each option keyword is quoted with double quotes ( " ), is followed by a colon ( : )
   and a value.
4. Each value may be a double-quoted string, a number, a boolean (true or false, not
   quoted), or a list of these items, separated by commas and enclosed in square
   brackets ( [] ).
5. Output filenames must be a full path to the file (or directory containing files)
  to be created in the :term:`Container`.  Output file must be placed in
  `/volumes/output` or a subdirectory of that location.  Output files and directories
  will be copied to the project directory data/output on the :term:`Host machine`.

Many commands include the optional parameters:

* log_console: this is a boolean value.  The value `true`, causes the command to
  print logging lines in the command line window, to show the processes and progress.
* log_filename: a full path to the output log file to be created.  The file is an
  `Output filename` as described above.  It contains all logging output from the
  process, and may be useful for identifying what processes were executed and their 
  outcomes.
* report_filename: a full path to the report log file to be created.  The file is an
  `Output filename` as described above.  It contains a summary of the modifications made
  to the output data, and may be useful for quantifying or comparing them.
