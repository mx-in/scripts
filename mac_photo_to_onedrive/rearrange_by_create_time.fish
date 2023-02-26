#!/bin/fish

if test (count $argv) -lt 2 
    echo "Usage: <ondrive photo directory> <photos directory>"
    return
end 

set from $argv[2]
set to $argv[1]

set files (find $from ! -path '*/.*'  -type f)
echo files count: (count $files)

for file in $files
    set creation_time (stat -f "%B" $file)
    echo $file $creation_time

    # Get year and month from timestamp
    set year (date -r $creation_time +%Y)
    set month (date -r $creation_time +%m)

    set distination $to/$year/$month

    # Create directory if not exists
    if not test -d $distination
        mkdir -p $distination
    end

    echo destination: $distination
    # Move file to distination
    mv -n $file $distination
    echo "Moved $file to $distination"
end

set unmoved_files (find $from ! -path '*/.*'  -type f)
f test (count $unmoved_files) -gt 0
    echo "Unmoved files:"
    for file in $unmoved_files
        echo $file
    end
    echo "There are some files that could not be moved. please check if they are already exist in your destination directory"
end
