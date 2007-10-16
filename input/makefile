update:
	make prebuild
	r2w.py
	make postbuild

prebuild:
	rm -f ../output/current

postbuild:
	ln -s ../output/0.1 ../output/current

update-manuals:
	#The following checkouts are just used to compile the documentation
	mkdir -p ../tmp/nmag-devel-manual
	cd ../tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk nmag-devel-manual
	cd ../tmp/nmag-devel-manual/doc/installation_manual; make

	cd ../tmp/nmag-devel-manual; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk nsim
	cd ../tmp/nmag-devel-manual/nsim; make
	cd ../tmp/nmag-devel-manual/nsim; make doc


update-svn-devel:
	#This is used for creation of the tar file
	echo "About to checkout repository (trunk)"
	mkdir -p ../tmp/nmag-devel/nsim
	cd ../tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk/ nmag-devel
	cd ../tmp/nmag-devel; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/trunk/ nsim


DATE=$(shell date +%Y-%m-%d-T%H-%M-%S)
MANUALDIR=../tmp/nmag-devel-manual
TFDIR=../tmp/nmag-devel
build-tarfile-devel:
	echo $(DATE)

	#create links for nmag manual into toplevel 'doc' dir
	cd $(TFDIR); pwd; rm -f doc/nmag
	cd $(TFDIR); cd doc; ln -s ../nsim/interface/nmag/manual nmag

	#copy compiled nmag manual
	rsync -auv --delete $(MANUALDIR)/nsim/interface/nmag/manual/* $(TFDIR)/nsim/interface/nmag/manual

	#copy (compiled) installation manual
	rsync -auv --delete $(MANUALDIR)/INSTALL $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.pdf $(TFDIR)
	rsync -auv --delete $(MANUALDIR)/INSTALL.html $(TFDIR)

	#start tar process
	cd ../tmp; sh ../bin/make_tar_file.sh nmag-devel




