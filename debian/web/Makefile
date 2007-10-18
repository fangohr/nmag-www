#!/usr/bin/make
# Move all packages that have been copied to debian/ to the appropriate places and adjust
# Packages.gz and Sources.gz

all:
	rm -rf debian/dists # start from clean sources
	mkdir debian/dists
	mkdir debian/dists/stable
	mkdir debian/dists/stable/unofficial
	mkdir debian/dists/stable/unofficial/binary-i386
	mkdir debian/dists/stable/unofficial/source
	mkdir debian/dists/unstable
	mkdir debian/dists/unstable/unofficial
	mkdir debian/dists/unstable/unofficial/binary-i386
	mkdir debian/dists/unstable/unofficial/source

	(mv *.deb debian/dists/stable/unofficial/binary-i386/ ; /bin/true)
	dpkg-scanpackages . /dev/null >Packages
	gzip -9 Packages
	(mv Packages.gz debian/dists/stable/unofficial/binary-i386/ ; /bin/true)
	(mv *.tar.gz *.dsc *.changes debian/dists/stable/unofficial/source/ ; /bin/true)
	dpkg-scansources . /dev/null >Sources
	gzip -9 Sources
	(mv Sources.gz debian/dists/stable/unofficial/source/ ; /bin/true)
	chmod -R go+rX debian/dists
