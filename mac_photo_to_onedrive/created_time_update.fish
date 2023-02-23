#!/bin/fish

echo updating files create time from $argv[1]

set start_time (date +%s)

set files (find $argv[1] ! -path '*/.*'  -type f)
echo files count: (count $files)

for i in (seq 1 (count $files))
    echo file $files[$i]
    set file_name (basename $files[$i])
    set parent (basename (dirname $files[$i]))
    set date_str (date -j -f "%Y年%m月%d日" $parent "+%Y%m%d%H%M")
    touch -t $date_str $files[$i]
    echo touching $parent $file_name $date_str
end

set end_time (date +%s)

echo create time update done!
echo "Star time $start_time, end time $end_time Duration: " (date -r (math "$end_time - $start_time") +%M:%S)
