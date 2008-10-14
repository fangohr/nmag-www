#!/bin/sh
tmpdir=/tmp/nmag_check_`date +"%Y-%m-%d-%H-%M-%S"`
echo $tmpdir
mkdir -p $tmpdir
echo "Which version do we use for the tests?:"
/usr/bin/nsimversion
echo "Will run one nmag regression test in $tmpdir"
echo "(starting in 5 seconds)."
sleep 5

cp -a /usr/lib/nsim/interface $tmpdir
chmod -R u+w $tmpdir
cd $tmpdir/interface/nmag/manual/example1
/usr/bin/pytest_nsim

echo "Tests completed. You may run 'rm -rf $tmpdir' to free some space on /tmp"
