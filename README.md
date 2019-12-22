# About

This repository stores the code used to build the nmag website only.
The documentation is built from http://github.com/fangohr/nmag-doc.

# Build Using Docker

1. Install docker from [docker.com](https://docs.docker.com/v17.09/engine/installation/#supported-platforms)
2. Run `build.sh`
3. Upon completion, the 'output' directory will contain the webroot for the site

# Build Natively

To build these webpages, you need r2w in your path
(http://www.voidspace.org.uk/python/rest2web/).

This is also available as a debian package 'rest2web'.

Just type 'make', and wait.

The html-root is produced in the 'output' directory.
