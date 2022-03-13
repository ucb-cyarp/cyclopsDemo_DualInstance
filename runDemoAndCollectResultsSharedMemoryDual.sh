oldDir=$(pwd)

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd $scriptSrc
scriptSrc=$(pwd)

resultDirName=$1

if [[ -z $resultDirName ]]; then
    echo "Please supply a result directory name"
    exit 1
fi

resultsDir="$scriptSrc/results/$resultDirName"

if [[ -e  $resultsDir ]]; then
    echo "Error: $resultsDir already exists"
    exit 1
fi

mkdir $resultsDir

#Get the CPU topology and put in results directory
python3 $scriptSrc/cpuTopology/cpuTopologyInfo.py > cpuTopology.txt

#Run the demos
cd $scriptSrc/cyclopsDemo_inst1/build
./runDemoAndCollectResultsSharedMemory.sh $resultsDir/instance1 &
instance1PID=$!

cd $scriptSrc/cyclopsDemo_inst2/build
./runDemoAndCollectResultsSharedMemory.sh $resultsDir/instance2 &
instance2PID=$!

cd $oldDir

instancePIDs=( "${instance1PID}" "${instance2PID}" )

#From https://stackoverflow.com/questions/356100/how-to-wait-in-bash-for-several-subprocesses-to-finish-and-return-exit-code-0
echo "Instance PIDs: ${instancePIDs[*]}"
wait "${instancePIDs[@]}"
