
res_file=ray_results.csv
tmp_file=ray_result.tmp

[ -e $tmp_file ] && rm $tmp_file
[ -e $res_file ] && rm $res_file

echo "DIM,THREADS,SPHERES,MEMORY,RENDER_TIME_MEDIAN,RENDER_TIME_MEAN,RENDER_TIME_SD" >> $res_file

trials=10
memory="1 0"
dims="512 1024 2048"
threads="16 32"
spheres="10 100 1000"

for dim in $dims
do

for thread in $threads
do

for sphere in $spheres
do

for mem in $memory
do

mem_name="const"
if [ $mem = 1 ]
then
    mem_name="global"
fi

[ -e $tmp_file ] && rm $tmp_file

echo "Starting $trials trails for settings DIM=$dim SPHERES=$sphere NUM-THREADS=$thread MEMORY=$mem_name"

for iter in $(seq 1 $trials)
do
    ./ray $dim $sphere $thread 0 $mem >> $tmp_file
done #trials

echo $dim,$thread,$sphere,$mem_name,$(python3 mean_sd.py $tmp_file) >> $res_file

done #memory settings

done #spheres

done #threads

done #dimensions

[ -e $tmp_file ] && rm $tmp_file
