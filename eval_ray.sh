
trials=2000

echo "" > ray_results.txt
echo "" > ray_noconst_results.txt

for iter in $(seq 1 $trials)
do
    ./ray >> ray_results.txt
    ./ray_noconst >> ray_noconst_results.txt
done 
