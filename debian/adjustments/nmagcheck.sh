#!/bin/sh
tmpdir=/tmp/nmagcheck/`date +"%Y-%m-%d-%H-%M-%S"`
echo $tmpdir
mkdir -p $tmpdir
echo "Which version do we use for the tests?:"
/usr/bin/nsimversion
echo "Will run one nmag regression test in $tmpdir"
#echo "(starting in 1 seconds)."
sleep 1

cp -a /usr/lib/nsim/interface $tmpdir
mkdir -p $tmpdir/bin
cp -a /usr/bin/nsim $tmpdir/bin
cp -a /usr/bin/ncol $tmpdir/bin
chmod -R u+w $tmpdir
echo "#"
echo "#"
echo "#"
echo "#"
echo "#"
echo "Testing interface/nsim"
echo "#"
echo "#"
cd $tmpdir/interface/nsim
/usr/bin/pytest_nsim -k "-test_slow" 
echo "#"
echo "#"
echo "#"
echo "#"
echo "#"
echo "Testing interface/nmag"
echo "#"
echo "#"
cd $tmpdir/interface/nmag
/usr/bin/pytest_nsim -k "-test_slow" 
echo "#"
echo "#"
echo "#"
echo "#"
echo "#"
echo "Quick tests completed. You may run 'rm -rf $tmpdir' to free some space on /tmp"
echo "Starting extended tests in 30 seconds (press CTRL+C to stop)"
sleep 30

cd $tmpdir/interface/nmag
/usr/bin/pytest_nsim 

echo "Tests completed. You may run 'rm -rf $tmpdir' to free some space on /tmp"
