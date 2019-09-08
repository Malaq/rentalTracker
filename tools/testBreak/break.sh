#!/bin/bash
input="$1"
while IFS= read -r line
do
  echo "$line"
  property=`echo $line | cut -f1 -d,`
  date_var=`echo $line | cut -f2 -d,`
  apt=`echo $line | cut -f3 -d,`
  bed=`echo $line | cut -f4 -d,`
  bath=`echo $line | cut -f5 -d,`
  sqft=`echo $line | cut -f6 -d,`
  lowprice=`echo $line | cut -f7 -d,`
  highprice=`echo $line | cut -f8 -d,`
  echo $property $date_var $apt $bed $bath $sqft $lowprice $highprice
  echo ${date_var}_$property.csv
  echo "$line" >> ${date_var}_$property.csv
done < "$input"
