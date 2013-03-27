#/bin/bash
# Quickly generate CREATE TABLE statement from a comma/tab/etc 
# delimited file header for easy file import.
# Author: Daniel Packer <dp@danielpacker.org>

TABLE=$1
FILE=$2
DELIM=$3
echo "DROP TABLE IF EXISTS $TABLE;"
echo -n "CREATE TABLE $TABLE ( "
head -1 $FILE | perl -n -e "chomp; print join(qq/ varchar(255), /, split(/$DELIM/)); print qq/ varchar(255)/;"
echo -n $RESULT
echo " );"


if [[ $4 ]]; then
  #echo "mysqlimport --fields-optionally-enclosed-by='\"' --fields-terminated-by='\$DELIM' --lines-terminated-by='\n' --user $4 --password $TABLE $FILE"
  echo "LOAD DATA INFILE $FILE INTO TABLE $TABLE FIELDS TERMINATED BY '$DELIM' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\\n' IGNORE 1 LINES;"
fi

