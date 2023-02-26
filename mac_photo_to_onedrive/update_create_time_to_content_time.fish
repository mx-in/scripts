#!/bin/fish

set DIR $argv[1]

if test -z "$DIR"
    echo "Usage: $argv[1] <directory>"
    exit 1
end

echo start to update files under $DIR
set files (find $DIR ! -path '*/.*'  -type f)
echo Found (count $files) files

# Set the directory to process
for file in $files
    set -l ctime (exiftool -s -s -s -createdate "$file")
    echo ":::::::::::: $ctime $(string length (string trim $ctime))"

    if test -n $ctime
        if test (string length (string trim $ctime)) -gt 0
            set formatted_time (date -j -f "%Y:%m:%d %H:%M:%S" $ctime "+%Y%m%d%H%M.%S")
            touch -c -t $formatted_time $file
            echo "Set creation time of $file to $formatted_time"
        end
    else 
        echo $fiel "has no creation time"
    end
end

echo "$(count files) files updated"
