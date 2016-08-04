if [ $# -ne 3 ]; then
  echo "ERROR: $# variables passed, 3 are required."
  echo "Syntax: `basename $0` property csv_file html_file"
  exit 1
fi

property="$1"
csv_file="$2"
parse_file="$3"

rundate="`echo $parse_file | cut -f1 -d\_ | rev | cut -f1 -d\/ | rev`"

echo "Property,Date,Unit,Bedroom,Bathroom,SQFT,Low Rent,High Rent" > $csv_file

bedroom=""
bathroom=""

while read line
do
  rent=""
  lowrent=""
  highrent=""
  unit=""
  sqft=""
  if [ "`echo $line | grep other-floorplans | wc -m`" -gt 0 ]; then
    bedroom=`echo $line | cut -f2 -d\: | cut -f1 -d\< | cut -f2 -d\- | cut -f1 -d\, | cut -f2 -d" "` 
    bathroom=`echo $line | cut -f2 -d\: | cut -f1 -d\< | cut -f2 -d\- | cut -f2 -d\, | cut -f2 -d" "` 
  else 
    rent="`echo $line | cut -f10 -d\> | cut -f1 -d\< | sed s/\,//g | sed 's/\\$//g'`"
    lowrent="`echo $rent | cut -f1 -d\-`"
    highrent="`echo $rent | cut -f2 -d\-`"
    unit="`echo $line | cut -f2 -d\> | cut -f1 -d\< | sed s/\#//g`"
    sqft="`echo $line | cut -f8 -d\> | cut -f1 -d\<`" 

    echo "Prop:$property Date:$rundate Apt:$unit $bedroom BR $bathroom BA $sqft sqft ${lowrent} - ${highrent} rent"
    echo "$property,$rundate,$unit,$bedroom,$bathroom,$sqft,$lowrent,$highrent" >> $csv_file 
  fi
done < $parse_file
