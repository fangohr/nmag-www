
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

rm -v INSTALL.pdf
rm -v INSTALL.html
rm -v INSTALL

ln -sv ../../INSTALL .
ln -sv ../../INSTALL.html .
ln -sv ../../INSTALL.pdf .

cd ../../

#get pkgs.tar.gz from somewhere and place it in nsimdist

#for nigthly build, this is done already

cd nsim
svnversionnsim=`svnversion`

echo "nsim rev $svnversionnsim" >> ../$infofile

echo "tar file created $versiondate" >> ../$infofile

echo "----------Details nsim repos:------" >> ../$infofile

svn info >> ../$infofile


echo "Removing obsolete and info directories"
rm -rf obsolete info

#update manual, copy from where we have built it before

cd ..

echo "----------Details nsimdist repos:--" >> $infofile

svn info >> $infofile

echo "untarring libraries"


#untar packages
/bin/tar xf /tmp/pkgs.tar

cd ..

filename=$name.tar.gz 

echo "Creating $filename"
tar czf $filename $name
