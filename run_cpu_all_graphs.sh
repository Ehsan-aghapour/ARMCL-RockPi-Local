
graphs=("graph_alexnet_n_pipe" "graph_googlenet_n_pipe" "graph_mobilenet_n_pipe" "graph_squeezenet_n_pipe" "graph_resnet50_n_pipe")
graphs=("graph_alexnet_n_pipe_npu" "graph_googlenet_n_pipe_npu" "graph_mobilenet_n_pipe_npu" "graph_squeezenet_n_pipe_npu" "graph_resnet50_n_pipe_npu")
path=/data/local/Work/ARMCL
path="/data/data/com.termux/files/home/ARMCL-RockPi"
res=cpu_res.log
mv $res "$res".old

if [ $1 -eq 1 ]
then
for graph in ${graphs[@]}
do
	PiPush /home/ehsan/UvA/ARMCL/Rock-Pi/ComputeLibrary_64/build/examples/NPU/"$graph" graphs/
done
fi

#sleep 10

cores=("B2-S0" "B2-S4" "B0-S4")
ncores=(2 6 4)
orders=("B" "B" "L")
for graph in ${graphs[@]}
   do
   echo "examination_graph:$graph" | tee -a $res
   i=0
   for c in ${cores[@]}
      do
      	 if [ $1 -eq 1 ]
      	 then 
      	 sleep 30
      	 fi
         echo -e '\n'$c'\n' | tee -a $res
	 echo -e 'number of cores:'${ncores[$i]}'\n' | tee -a $res
	 g=`echo $graph | cut -f2 -d_ `
	 g=assets_"$g"
	 PiTest $graph graphs NEON 0 0 0 60 0 0 100 100 ${orders[$i]} 0 ${ncores[$i]} ${ncores[$i]} | tee -a $res
	 ((i=i+1))	 
      done	
 
   done
   
awk -F'[ :,\/]' 'BEGIN{j=0;z[0]="";z[1]="B2-S0";z[2]="B2-S4";z[3]="B0-S4";} /examination_graph/{graph=$2; z[0]=z[0] OFS graph} /B[0-9]-S[0-9]/{k=$1;for(i in z){if(index(z[i] , k)!=0){ j=i}}} /total0_time/ {z[j]=z[j] OFS $2} END{ for(ii in z){print z[ii]}  }' OFS=, "$res" > `echo "$res" | cut -f1 -d.`_2.csv




