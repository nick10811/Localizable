# !/bin/bash
#  Program:
#        This program convert file between Localizable.strings and csv.
#
# Created by Nick Yang on 2020/6/15.
# Copyright © 2020 Nick Yang All rights reserved.

OUTPUT_FILE="Localizable"

_csv2strings() {
    exec < $1
    OUTPUT=$OUTPUT_FILE.strings
    echo "/*" >> $OUTPUT
    echo " * $OUTPUT" >> $OUTPUT
    echo " *" >> $OUTPUT
    echo " * Created by https://github.com/nick10811" >> $OUTPUT
    echo " */" >> $OUTPUT
    echo "" >> $OUTPUT 
    while IFS=',' read -r col1 col2
    do
        echo "\"$col1\" = \"$col2\";" >> $OUTPUT
    done
}

_strings2csv() {
    exec < $1
    while IFS='=' read -r col1 col2
    do
        if [[ -n $col1 ]] && [[ -n $col2 ]]; then
            SUBSTRING1=`echo "$col1" | cut -d'"' -f 2`
            SUBSTRING2=`echo "$col2" | cut -d'"' -f 2`
            echo "$SUBSTRING1,$SUBSTRING2" >> $OUTPUT_FILE.csv
        fi
    done
}

_showUsage() {
    echo ""
    echo "usage: ./localizable.sh source_file"
    echo "accept file extension: csv, strings"
}

###
# Main
###
_main() {
    EXTENSION=`basename $1 | cut -d '.' -f2`
    echo "Input file: $1"
    echo "###########"
    if [[ $EXTENSION == "csv" ]]; then
        _csv2strings $1
        echo "Output file: $OUTPUT_FILE.strings"
    elif [[ $EXTENSION == "strings" ]]; then
        _strings2csv $1
        echo "Output file: $OUTPUT_FILE.csv"
    else
        [ ! -f $1 ] && { echo "$@ file not found"; }
        _showUsage
        exit 99;
    fi
}

_main $@
