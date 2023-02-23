function gi
    set temp ".temp"
    curl -sL https://www.toptal.com/developers/gitignore/api/$argv > $temp
    sed '/^#.*http/d' $temp > .gitignore
    rm $temp
    cat .gitignore
end
