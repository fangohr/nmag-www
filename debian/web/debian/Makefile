#!/usr/bin/make
# Move all packages that have been copied to debian/ to the appropriate places and adjust
# Packages.gz and Sources.gz

all:
	rm -rf dists # start from clean sources
	mkdir dists
	mkdir dists/stable
	mkdir dists/stable/unofficial
	mkdir dists/stable/unofficial/binary-i386
	mkdir dists/stable/unofficial/source
	mkdir dists/unstable
	mkdir dists/unstable/unofficial
	mkdir dists/unstable/unofficial/binary-i386
	mkdir dists/unstable/unofficial/source

	(mv *.deb dists/stable/unofficial/binary-i386/ ; /bin/true)
	dpkg-scanpackages . /dev/null >Packages
	gzip -9 Packages
	(mv Packages.gz dists/stable/unofficial/binary-i386/ ; /bin/true)
	(mv *.tar.gz *.dsc *.changes dists/stable/unofficial/source/ ; /bin/true)
	dpkg-scansources . /dev/null >Sources
	gzip -9 Sources
	(mv Sources.gz dists/stable/unofficial/source/ ; /bin/true)
	chmod -R go+rX dists
