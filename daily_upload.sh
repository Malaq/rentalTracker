script_dir="`dirname $0`"
fs="/mnt/pub/Uploads"
#cd $dir
echo "Beginning file merge of all historical data..."
${script_dir}/merge_data.sh > ${script_dir}/large.csv
echo "Copying data to ${fs}/large.csv..."
cp ${script_dir}/large.csv ${fs}/large.csv 
rc=$?

if [ "$rc" -eq "0" ]; then
echo "Daily upload complete."
else
echo "Error copying file. Please make sure the $fs is mounted correctly."
fi
