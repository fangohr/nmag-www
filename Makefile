WEBSERVER=152.78.138.239
DATE=$(shell date +%Y-%m-%d-T%H-%M-%S)
MREV=0.2

WEBROOT=webroot


#run r2w and copy updated static html to local webroot
r2w:
	cd input; bash update.sh
	rsync -rvu output/* $(WEBROOT)

#copy local webroot folder to server
publish:
	#rsync -rvu -e ssh $(WEBROOT)/* www-data@$(WEBSERVER)://var/www/nmag
	rsync -rvu -e ssh $(WEBROOT)/* $(WEBSERVER)://home/www-data/nmag

fetch-docs:
	mkdir -p webroot/$(MREV)/manual
	echo "Getting documenation from ../doc"
	cp -vr ../doc/nmag/_build/latex/NMAGUserManual.pdf webroot/$(MREV)/manual/manual.pdf
	cp -rv ../doc/nmag/_build/html webroot/$(MREV)/manual
	cp -rv ../doc/nmag/_build/singlehtml webroot/$(MREV)/manual	
	cp input/0.2/install/_a_index input/0.2/install/install_a.txt
	cat  ../dist/INSTALL >> input/0.2/install/install_a.txt











