#Tool to support putting together of virtual machine zip files
#Currently, the master vmware is sitting on iota:/Users/fangohr/Virtual\ Machines/
#Hans, 22/12/2009
REV=6481
mv vmp/nmag-0.1 vmp/nmag-0.1-backup
mkdir -p vmp/nmag-0.1
cp -va phi_lenny32.vmwarevm/* vmp/nmag-0.1
pushd vmp
zip -r nmag-0.1-$REV-vmware-part1.zip nmag-0.1/lenny32-s00[1234567].vmdk
zip -r nmag-0.1-$REV-vmware-part2.zip nmag-0.1/lenny32-s00[89].vmdk nmag-0.1/lenny32-s010.vmdk nmag-0.1/lenny32-s011.vmdk nmag-0.1/lenny32.* nmag-0.1/quicklook-cache.png nmag-0.1/vmware*.log

popd



