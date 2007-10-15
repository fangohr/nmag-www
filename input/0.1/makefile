updatesvn:
	svn export svn+ssh://alpha.kk.soton.ac.uk/var/local/svn/nsimdist/trunk/INSTALL install/INSTALL
	cd install; cat _install_A INSTALL > install_a.txt



prebuild:
	rm current

postbuild:
	ln -s 0.1 current



all:
	updatesvn
	make_install.py
	update

