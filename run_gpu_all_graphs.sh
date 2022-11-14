


graphs=("graph_alexnet_n_pipe" "graph_googlenet_n_pipe" "graph_mobilenet_n_pipe" "graph_squeezenet_n_pipe" "graph_resnet50_n_pipe")
path=/data/local/Work/ARMCL
path="/data/data/com.termux/files/home/ARMCL-RockPi"
res=gpu_res.log
mv $res "$res".old

export LD_LIBRARY_PATH=/vendor/lib64/

if [ $1 -eq 1 ]
then
for graph in ${graphs[@]}
do
	PiPush /home/ehsan/UvA/ARMCL/Rock-Pi/ComputeLibrary_64/build/examples/"$graph" graphs/
done
fi

for graph in ${graphs[@]}
do
	sleep 30
	echo "examination_graph:$graph" | tee -a $res
	g=`echo $graph | cut -f2 -d_ `
	#examples/$graph --target=CL --threads=$1 --image=/data/local/Work/ARMCL/assets/assets_"$g"/ppm_images/ --labels=/data/local/Work/ARMCL/assets/assets_"$g"/labels.txt | tee -a $res
	PiTest $graph graphs CL 0 0 0 60 0 0 100 100 G 0 2 4 --type=U8 | tee -a $res
	#sleep 30
done

#res_csv=`echo $res | cut -f1 -d. `

awk -F'[ :,\/]' 'BEGIN{z[0]="Graph";z[1]="Input";z[2]="Task";z[3]="Output";z[4]="total"} /examination_graph/{graph=$2; z[0]=z[0] OFS graph} /input0_time/ {z[1]=z[1] OFS $2} /task0_time/ {z[2]=z[2] OFS $2} /output0_time/ {z[3]=z[3] OFS $2} /total0_time/ {z[4]=z[4] OFS $2} END{ for(i in z){print z[i]}  }' OFS=, "$res" > `echo "$res" | cut -f1 -d.`.csv
