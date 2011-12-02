WEBSERVER=152.78.138.239
DATE=$(shell date +%Y-%m-%d-T%H-%M-%S)

WEBROOT=webroot


#run r2w and copy updated static html to local webroot
r2w:
	cd input; bash update.sh
	rsync -rvu output/* $(WEBROOT)

#copy local webroot folder to server
publish:
	rsync -rvu -e ssh $(WEBROOT)/* www-data@$(WEBSERVER)://var/www/nmag











