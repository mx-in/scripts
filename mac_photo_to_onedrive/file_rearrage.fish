#!/bin/fish
if test (count $argv) -lt 2 
    echo "Usage: <ondrive photo directory> <photos directory>"
    return
end 

function first_file_name
    if test (count $argv) -lt 1
        echo "Usage: first_file_name <directory>"
        return
    end
    echo (ls -1 $argv[1] | head -n 1)
end

echo rearranging files
echo from: $argv[2]
echo to: $argv[1]

set onedrive_p_path $argv[1]
set iphoto_path $argv[2]

set first_onedrive_file (first_file_name $onedrive_p_path)
set first_iphoto_file (first_file_name $iphoto_path)

if test -n $first_onedrive_file && not string match -rq '^\d{4}$' $first_onedrive_file 
    echo "onedrive photo directory '$first_onedrive_file' is not in YYYY format"
    return
end

if not string match -rq '^\d{4}年\d{1,2}月\d{1,2}日$' $first_iphoto_file
    echo "mac photo directory '$first_iphoto_file'  is not in YYYY年MM月DD日 format"
    return
end

set files (find $iphoto_path ! -path '*/.*'  -type f)
echo files count: (count $files)

set start_time (date +%s)

for i in (seq 1 (count $files))
    set file $files[$i]
    set parent_dir_name (basename (dirname $files[$i]))
    set month_str (date -j -f "%Y年%m月%d日" $parent_dir_name "+%m")
    set year_str (date -j -f "%Y年%m月%d日" $parent_dir_name "+%Y")
    set target_dir $onedrive_p_path$year_str/$month_str
    if not test -d $target_dir
        echo not exists $target_dir
        mkdir -p $target_dir
    end
    mv -f $file $target_dir
end

set end_time (date +%s)

echo "Star time $start_time, end time $end_time Duration: " (date -r (math "$end_time - $start_time") +%M:%S)

