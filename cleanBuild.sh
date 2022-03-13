oldDir=$(pwd)

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd $scriptSrc
scriptSrc=$(pwd)

cd $scriptSrc/cyclopsDemo_inst1/build
./cleanBuild.sh $1
cd $scriptSrc/cyclopsDemo_inst2/build
./cleanBuild.sh $1

cd $oldDir
