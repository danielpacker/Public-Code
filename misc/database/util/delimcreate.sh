#/bin/bash
# Quickly generate CREATE TABLE statement from a comma/tab/etc 
# delimited file header for easy file import.
# Author: Daniel Packer <dp@danielpacker.org>

TABLE=$1
FILE=$2
DELIM=$3
echo "DROP TABLE IF EXISTS $TABLE"
echo -n "CREATE TABLE $TABLE ( "
head -1 $FILE | perl -n -e "chomp; print join(qq/ varchar(255), /, split(/$DELIM/)); print qq/ varchar(255)/;"
echo -n $RESULT
echo " )"


