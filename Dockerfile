from alpine

add . /nmag-www
workdir /nmag-www

# Install dependencies
run apk --no-cache add make bash python py2-pip rsync
run pip install docutils

# Extract and link r2w
run tar xzvf rest2web-0.5.1.tar.gz
run chmod 755 rest2web-0.5.1/r2w.py
run ln -s /nmag-www/rest2web-0.5.1/r2w.py /bin/r2w

# Compile the docs
run make
