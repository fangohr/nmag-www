#WEBSERVER=nmag.soton.ac.uk
WEBSERVER=152.78.96.206

all:	update-0.1 update-devel

update-html:
	make prebuild-html
	cd input; r2w
	make postbuild-html

prebuild-html:
	rm -f output/current
	cat input/0.1/install/_a_index input/0.1/install/_a_INSTALL > input/0.1/install/install_a.txt

postbuild-html:
	cd output; ln -s 0.1 current


update-manuals-devel:
	#The following checkouts are just used to compile the documentation
	mkdir -p tmp/nmag-devel-manual
	cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk nmag-devel-manual
	cd tmp/nmag-devel-manual/doc/installation_manual; make

	cd tmp/nmag-devel-manual; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk nsim
	cd tmp/nmag-devel-manual/nsim; make
	cd tmp/nmag-devel-manual/nsim; make doc


update-svn-devel:
	#This is used for creation of the tar file
	echo "About to checkout repository (trunk)"
	mkdir -p tmp/nmag-devel/nsim
	cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk/ nmag-devel
	cd tmp/nmag-devel; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk/ nsim
	cd tmp/nmag-devel/nsim; svnversion > ../../../input/devel/svnversion



MANUALDIR=tmp/nmag-devel-manual
TFDIR=tmp/nmag-devel
build-tarfile-devel:
	#create links for nmag manual into toplevel 'doc' dir
	cd $(TFDIR); pwd; rm -f doc/nmag
	cd $(TFDIR); cd doc; ln -s nsim/interface/nmag/manual nmag

	cd tmp; tar cfvz nmag-devel-core.tar.gz nmag-devel/nsim
	mv tmp/nmag-devel-core.tar.gz output/devel/download

	#copy compiled nmag manual
	rsync -auv --delete $(MANUALDIR)/nsim/interface/nmag/manual/* $(TFDIR)/nsim/interface/nmag/manual

	#copy (compiled) installation manual
	rsync -auv --delete $(MANUALDIR)/INSTALL $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.pdf $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.html $(TFDIR)

	#start tar process
	cd tmp; sh ../bin/make_tar_file.sh nmag-devel

	mv tmp/nmag-devel.tar.gz output/devel/download

build-with-manuals-0.1:
	#The following checkouts are just used to compile the documentation
	mkdir -p tmp/nmag-0.1-manual
	#cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/branches/0.1 nmag-0.1-manual
	cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk nmag-0.1-manual
	cd tmp/nmag-0.1-manual/doc/installation_manual; make

	#cd tmp/nmag-0.1-manual; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/branches/0.1 nsim	
	cd tmp/nmag-0.1-manual; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk nsim
	cd tmp/nmag-0.1-manual/nsim; make
	cd tmp/nmag-0.1-manual/nsim; make doc


update-manuals-0.1: build-with-manuals-0.1
	#copy to final destination
	rsync -auv tmp/nmag-0.1-manual/nsim/interface/nmag/manual/* output/0.1/manual
	rsync -auv tmp/nmag-0.1-manual/INSTALL input/0.1/install/_a_INSTALL



update-svn-0.1:
	#This is used for creation of the tar file
	echo "About to checkout repository (trunk)"
	mkdir -p tmp/nmag-0.1/nsim
	cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk/ nmag-0.1
	cd tmp/nmag-0.1; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk/ nsim
	cd tmp/nmag-0.1/nsim; svnversion > ../../../input/0.1/svnversion


DATE=$(shell date +%Y-%m-%d-T%H-%M-%S)
MANUALDIR=tmp/nmag-0.1-manual
TFDIR=tmp/nmag-0.1
build-tarfile-0.1:
	echo $(DATE)

	#create links for nmag manual into toplevel 'doc' dir
	cd $(TFDIR); pwd; rm -f doc/nmag
	cd $(TFDIR); cd doc; ln -s nsim/interface/nmag/manual nmag

	#copy compiled nmag manual
	rsync -auv --delete $(MANUALDIR)/nsim/interface/nmag/manual/* $(TFDIR)/nsim/interface/nmag/manual

	#copy (compiled) installation manual
	rsync -auv --delete $(MANUALDIR)/INSTALL $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.pdf $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.html $(TFDIR)

	#start tar process
	cd tmp; sh ../bin/make_tar_file.sh nmag-0.1

	mv tmp/nmag-0.1.tar.gz output/0.1/download



#These are the two useful targets:

update-0.1: update-manuals-0.1 update-svn-0.1 build-tarfile-0.1 update-html

update-devel: update-manuals-devel update-svn-devel build-tarfile-devel update-html

debian-package: build-with-manuals-0.1
	rsync -av --delete --exclude '*~' --exclude '.svn' tmp/nmag-0.1/nsim/interface/* debian/packages/nsim-0.1/interface/
	cp -a tmp/nmag-0.1-manual/nsim/bin/n* debian/packages/nsim-0.1/bin/
	cp debian/adjustments/* debian/packages/nsim-0.1/bin/
	./add-svnversion-to-debian-changelog.pl 0.1
	cp -a tmp/nmag-0.1-manual/nsim/pyfem3/pyfem3 debian/packages/nsim-0.1/bin/pyfem
	cd debian/packages/nsim-0.1; debuild -us -uc
	mv debian/packages/nsim_*.{dsc,changes,deb,tar.gz} debian/web/
	cd debian/web; make

#I suspect we run 'make update-0.1' only when we have anything useful and new to release.
#'make update-devel' could be run every morning to release a new developers' version.

web-publish: update-0.1 update-devel debian-package
	rm -rf output/debian
	rsync -av debian/web/debian/ output/debian/
	rsync -avz --exclude '.svn' --delete -e ssh output/* www-data@$(WEBSERVER):/var/local/www/virtual-hosts/nmag/webroot/nmag/
