first=Y
data_path="`dirname $0`"

for csv in `find ${data_path}/data/ | grep .csv`
do
  #echo "CSV: $csv"
  length="`cat $csv | wc -l`"
  if [ "$first" == "Y" ]; then
    first="N"
  else
    length="`echo $length-1 | bc`"
  fi
  #echo "Length: $length"
  tail -n $length $csv
done
