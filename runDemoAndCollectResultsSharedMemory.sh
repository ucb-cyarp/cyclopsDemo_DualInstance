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
#From https://stackoverflow.com/questions/1908610/how-to-get-process-id-of-background-process
instance1PID=$1

cd $scriptSrc/cyclopsDemo_inst2/build
./runDemoAndCollectResultsSharedMemory.sh $resultsDir/instance1 &
instance2PID=$1

cd $oldDir

#From https://stackoverflow.com/questions/356100/how-to-wait-in-bash-for-several-subprocesses-to-finish-and-return-exit-code-0
wait $instance1PID
wait $instance2PID