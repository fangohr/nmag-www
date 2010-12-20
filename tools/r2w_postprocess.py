import sys
fname = sys.argv[1]

lines = open(fname,'r').readlines()


#this fixes an r2w bug that only shows with certain browsers.
keyword = 'http:/'

for i in range(len(lines)):
    if keyword in lines[i]:
        next_char = lines[i].index(keyword)+len(keyword)
        if lines[i][next_char] != '/':
            lines[i] = lines[i].replace(keyword,keyword+'/')
            print "change http:/ -> http:// in %s " % fname

#this is another hack as r2w seems to strip off any '../' from target URLS (for example
#input/wiki.txt). Agree that if we find '\../' we replace it with '../'.
#
#Can consider moving to Sphynx, Wiki or other system in future.
keyword = '\../'
for i in range(len(lines)):
    if keyword in lines[i]:
            lines[i] = lines[i].replace(keyword,'../')
            print "change \../ -> ../ in %s " % fname


f=open(fname,'w')
for line in lines:
    f.write('%s' % line)
f.close()



        
