set -e

prep_dir() {
  if [ -d "$data_dir/$1" ]; then
    debug "$1 directory already exists."
  else
    debug "Creating directory $data_dir/$1"
    mkdir $data_dir/$1
  fi
}

msg() {
  log "INFO" "$1"
}

debug() {
  log "DEBUG" "$1"
}

log() {
  type="$1"
  message="$2" 
  
  echo "$1: $2"
}

#####################
#
#  MAIN
#
#####################
startdate=`date`
debug "Start: $startdate"
rundate="`date +%Y-%m-%d`"
script_dir="`dirname $0`"
debug "script_dir: $script_dir"
tmp_dir="${script_dir}/tmp"
data_dir="${script_dir}/data"
config_dir="${script_dir}/config"
property_dir="${script_dir}/properties"

for config_file in `ls ${config_dir}/ | grep .cfg`
do
  complex="`echo $config_file | cut -f1 -d.`"
  url="`grep URL= ${config_dir}/${config_file} | cut -f2- -d=`"
  grepstring="`grep GREPSTRING= ${config_dir}/${config_file} | cut -f2- -d=`"
  property_type="`grep PROPERTY_TYPE= ${config_dir}/${config_file} | cut -f2- -d=`"

  msg "Complex: $complex"
  debug "URL: $url"
  debug "GREPSTRING: $grepstring"

  # Prepare the data dir
  prep_dir "$complex"

  curr_data_dir="$data_dir/$complex"
  raw_html_file="$tmp_dir/${rundate}_${complex}_raw.html"
  clean_html_file="$tmp_dir/${rundate}_${complex}_clean.html"


  #pull html
  echo "$url" > $raw_html_file

  for website in $url
  do
    debug "Pulling page: $website"
    phantomjs ${config_dir}/save_page.js ${website} >> ${raw_html_file}
  done

  #Remove html tags: sed "s/<[^>]\+>//g"
  grep "$grepstring" ${raw_html_file} > ${clean_html_file}
  ${property_dir}/${property_type}_properties.sh "$complex" "$curr_data_dir/${rundate}_${complex}.csv" "$clean_html_file"
done

${script_dir}/merge_data.sh > ${script_dir}/large.csv

enddate=`date`
debug "End: $enddate"
startsec="`date -d "$startdate" +%s`"
endsec="`date -d "$enddate" +%s`"
debug "Runtime: `echo "$endsec - $startsec" | bc` seconds."

#phantomjs save_page.js http://www.thecenturyseattle.com/apartments/wa/seattle/floor-plans#/bedrooms/all/floorplans > century.log

