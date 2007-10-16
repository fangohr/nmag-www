
version=$1

echo "version is $version"

name=$version

versiondate="`date +%Y-%m-%d-T%H-%M-%S`"

echo "Building ${version}.tar.gz"

homedir=`pwd`

cd $version

svnversionnsimdist=`svnversion`

infofile=VERSION

echo "$version" > $infofile

echo "nsimdist rev $svnversionnsimdist" >> $infofile


#update copies of installation manual in subdir
cd doc/installation_manual

rm INSTALL.pdf
rm INSTALL.html
rm INSTALL

ln -s ../../INSTALL .
ln -s ../../INSTALL.html .
ln -s ../../INSTALL.pdf .

cd ../../

#get pkgs.tar.gz from somewhere and place it in nsimdist

#for nigthly build, this is done already

cd nsim
svnversionnsim=`svnversion`

echo "nsim rev $svnversionnsim" >> ../$infofile

echo "tar file created $versiondate" >> ../$infofile

echo "----------Details nsim repos:------" >> ../$infofile

svn info >> ../$infofile


rm -rvf obsolete

#update manual, copy from where we have built it before

cd ..

echo "----------Details nsimdist repos:--" >> $infofile

svn info >> $infofile

echo "current directory is `pwd`"

#untar packages
/bin/tar xvf /tmp/pkgs.tar

cd ..

filename=$name.tar.gz 

tar cfvz $filename $name
#mv $name nsimdist

mv $filename /tmp

#scp /tmp/$filename alpha.kk.soton.ac.uk:/tmp
