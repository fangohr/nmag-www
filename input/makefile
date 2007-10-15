update:
	make prebuild
	r2w.py
	make postbuild

prebuild:
	rm ../output/current

postbuild:
	ln -s ../output/0.1 ../output/current

