WEBSERVER=nmag.soton.ac.uk
DATE=$(shell date +%Y-%m-%d-T%H-%M-%S)
LIBSOURCE_FILE=/var/local/www/webroot/nmag/pkgs.tar
TAR_SVNEXCLUDE=--anchored --exclude=*.svn --exclude=*/*.svn --exclude=*/*/*.svn --exclude=*/*/*/*.svn --exclude=*/*/*/*/*.svn --exclude=*/*/*/*/*/*.svn

# Note: this variable can and will be overridden via "make NSIM_VERSION=0.1 all".

NSIM_VERSION=devel
NSIM_BRANCH=$(patsubst tags/release/devel,trunk,tags/release/$(NSIM_VERSION))

DEBVERSION=$(NSIM_VERSION:devel=0.9999)
SRCDIR=nsim-$(NSIM_VERSION)

INST_SYSTEMDIR=tmp/nmag-$(NSIM_VERSION)

all: html-toplevel r2w-call current-link tarballs debian-package

# === KNOWN VERSIONS ===

devel:
	make -f Makefile NSIM_VERSION=devel all

# Experimental branch to test this version-aware build system:
0.099:
	make -f Makefile NSIM_VERSION=0.099 all


# Does not exist yet:
0.1:
	make -f Makefile NSIM_VERSION=0.1 all

# === /KNOWN VERSIONS ===

mrproper:
	rm -rf tmp/*
	rm -rf output/*/download/*.tar.gz
	rm -rf webserver-webroot/*

webroot: 
	mkdir webserver-webroot || /bin/true # ensure it exists
	rsync -auv --exclude .svn output/* webserver-webroot/nmag/
	rsync -auv --exclude Makefile --exclude .svn debian/web/debian/ webserver-webroot/debian/


# This introduces the link current -> [current version]:

current-link:
	rm -f output/current
	#	cd output; ln -s devel current
	cd output; ln -s 0.1 current


# This builds the "outer" HTML structure which contains general
# explanations on installation, etc.  plus links to the individual
# versions:

#The pure r2w-stuff

r2w-call: 
	svn export svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/$(NSIM_BRANCH)/svnversion input/$(NSIM_VERSION)/svnversion
	svn export svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/$(NSIM_BRANCH)/interface/nmag4/RELEASE input/$(NSIM_VERSION)/release_version.uyu
	cd input; r2w


html-toplevel: manuals
	cat input/$(NSIM_VERSION)/install/_a_index input/$(NSIM_VERSION)/install/_a_INSTALL > input/$(NSIM_VERSION)/install/install_a.txt

installation-system:
	mkdir -p $(INST_SYSTEMDIR)/nmag
	svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/dist/src $(INST_SYSTEMDIR)/nmag
	cd $(INST_SYSTEMDIR)/nmag/doc/installation_manual; make


nsim:
	cd tmp; mkdir -p nsim-build/nmag
	cd tmp/nsim-build/nmag; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/$(NSIM_BRANCH) nsim
	cd tmp/nsim-build/nmag/nsim; make all doc


fetchtrunk:
	#This is used for the creation of the tar file
	echo "About to do a clean checkout from the repository (trunk) for the distribution."
	cd tmp; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/dist/src/ $(SRCDIR)
	mkdir -p tmp/$(SRCDIR)/nmag
	cd tmp/$(SRCDIR)/nmag; svn co svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsim/$(NSIM_BRANCH) nsim
	cd tmp/$(SRCDIR)/nmag/nsim; svnversion > ../../../../input/$(NSIM_VERSION)/svnversion
	# cd tmp/$(SRCDIR)/nmag/nsim; make interface/nsim/svnversion.py
	echo "XXX make svnversion.py NOT DONE. First, this does not work, second, we do not want to build pyfem in the bare source directory. (Why is this necessary at all?)"


tarballs: fetchtrunk installation-system nsim
	#create links for nmag manual into toplevel 'doc' dir
	mkdir -p output/$(NSIM_VERSION)/download
	rm -rf tmp/$(SRCDIR)/nmag/doc/nmag
	mkdir -p tmp/$(SRCDIR)/nmag/doc/nmag
	ln -s nsim/interface/nmag/manual tmp/$(SRCDIR)/nmag/doc/nmag


	echo " *** REMOVING OLD TARBALLS *** "

	rm -f output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)*.tar*

	echo " *** CREATING CORE NMAG BUILD ARCHIVE *** "

	tar --directory $(INST_SYSTEMDIR) $(TAR_SVNEXCLUDE) -cvf output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-core.tar nmag

	echo " *** ADDING NSIM SOURCES ARCHIVE *** "

	echo "tarball" >tmp/$(SRCDIR)/nmag/nsim/interface/nmag/DISTMODE

	tar --directory tmp/$(SRCDIR) $(TAR_SVNEXCLUDE) --exclude=nmag/nsim/info -rf output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-core.tar nmag/nsim nmag/doc

	rm tmp/$(SRCDIR)/nmag/nsim/interface/nmag/DISTMODE

	# This should not be necessary, as we built that manual anyway when we made installation-system:
	#tar --directory $(INST_SYSTEMDIR) -rf output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-all.tar nmag/INSTALL.pdf nmag/INSTALL.html

	echo " *** ADDING MANUAL TO ARCHIVE *** "

	tar --directory tmp/nsim-build $(TAR_SVNEXCLUDE) -rf output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-core.tar nmag/nsim/interface/nmag/manual

	cp output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-core.tar \
           output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-all.tar

	echo " *** ADDING PACKAGE SOURCES TO BIG ARCHIVE *** "

	tar --directory tmp -Af output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-all.tar $(LIBSOURCE_FILE)

	echo " *** ZIPPING TARBALLS *** "

	# Gzip final tarballs:
	gzip -9 output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-core.tar
	gzip -9 output/$(NSIM_VERSION)/download/nmag-$(NSIM_VERSION)-all.tar

manuals: installation-system nsim
	#copy to final destination
	rsync -auv tmp/nsim-build/nmag/nsim/interface/nmag/manual/* output/$(NSIM_VERSION)/manual
	rsync -auv $(INST_SYSTEMDIR)/nmag/INSTALL input/$(NSIM_VERSION)/install/_a_INSTALL


debian-package: nsim manuals fetchtrunk
	rsync -av --delete --exclude '*~' --exclude '.svn' tmp/nsim-build/nmag/nsim/interface/* debian/packages/nsim/interface/
	cp -a tmp/nsim-build/nmag/nsim/bin/n* debian/packages/nsim/bin/
	cp debian/adjustments/* debian/packages/nsim/bin/
	bin/svnversion-to-debian-changelog.pl $(DEBVERSION)
	cp -a tmp/nsim-build/nmag/nsim/pyfem3/pyfem3 debian/packages/nsim/bin/pyfem
	cd debian/packages/nsim; debuild -us -uc
	mv debian/packages/nsim_*.{dsc,changes,deb,tar.gz} debian/web/
	cd debian/web; rm debian; ln -s . debian
	cd debian/web; make

# NOTE: not adjusted yet:

#web-publish: webroot

web-publish:
	rsync -avz --exclude '.svn' --delete -e ssh webserver-webroot/nmag/ www-data@$(WEBSERVER):/var/local/www/virtual-hosts/nmag/webroot/nmag/



	# Hans insists on having the tarball use a different toplevel directory name.
        # We repackage on the webserver:

web-repackage:
	ssh www-data@$(WEBSERVER) "cd /var/local/www/virtual-hosts/nmag/webroot/nmag/$(NSIM_VERSION)/download; echo 'OK 1'; tar xzf nmag-$(NSIM_VERSION)-core.tar.gz; echo 'OK 2'; mv nmag nmag-$(NSIM_VERSION); echo 'OK 3'; rm nmag-$(NSIM_VERSION)-core.tar.gz; tar cvzf nmag-$(NSIM_VERSION)-core.tar.gz nmag-$(NSIM_VERSION); echo 'OK 4'; rm -rf nmag-$(NSIM_VERSION); tar xzf nmag-$(NSIM_VERSION)-all.tar.gz; echo 'OK 5'; mv nmag nmag-$(NSIM_VERSION); echo 'OK 6'; rm nmag-$(NSIM_VERSION)-all.tar.gz; echo 'OK 7'; tar cvzf nmag-$(NSIM_VERSION)-all.tar.gz nmag-$(NSIM_VERSION); rm -rf nmag-$(NSIM_VERSION)"

# XXX NOTE: add .PHONY line!
