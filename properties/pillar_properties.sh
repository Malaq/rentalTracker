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
first=1
rent=""
lowrent=""
highrent=""
unit=""
sqft=""

while read line
do
  #if new apartment
  if [ "`echo $line | grep floorplan-card | wc -m`" -gt 0 ]; then
    #only print on new apartments, not the first
    if [ "$first" -eq 1 ]; then
      first=0
    else
      echo "Prop:$property Date:$rundate Apt:$unit $bedroom BR $bathroom BA $sqft sqft ${lowrent} - ${highrent} rent"
      echo "$property,$rundate,$unit,$bedroom,$bathroom,$sqft,$lowrent,$highrent" >> $csv_file 
    fi    

    bedroom=`echo $line | cut -f3 -d\> | cut -f1 -d\< | cut -f1 -d" "` 
    if [ "$bedroom" == "Studio" ]; then
      bedroom=0
    fi

    unit="`echo $line | cut -f3 -d\> | cut -f1 -d\< | cut -f1 -d\& | rev | cut -f1 -d" "| rev `"
  elif [ "`echo $line | grep unit-baths | wc -m`" -gt 0 ]; then
    bathroom=`echo $line | cut -f3 -d\> | cut -f1 -d\<` 
  elif [ "`echo $line | grep unit-size | wc -m`" -gt 0 ]; then
    sqft=`echo $line | cut -f2 -d\> | cut -f1 -d\< | sed s/" Sq. Ft."//g` 
  elif [ "`echo $line | grep unit-rate | wc -m`" -gt 0 ]; then
    rent=`echo $line | cut -f3 -d\> | cut -f1 -d\< | sed s/"From "//g | sed 's/\\$//g'` 
    lowrent="`echo $rent`"
    highrent="`echo $rent`"
  fi
done < $parse_file

#Echo the last line out
echo "Prop:$property Date:$rundate Apt:$unit $bedroom BR $bathroom BA $sqft sqft ${lowrent} - ${highrent} rent"
echo "$property,$rundate,$unit,$bedroom,$bathroom,$sqft,$lowrent,$highrent" >> $csv_file 
