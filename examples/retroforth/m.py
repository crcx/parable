import struct
import os
import sys

imgpath = 'retroImage'

# print "imgpath:", imgpath
cells = int(os.path.getsize(imgpath) / 4)
f = open( imgpath, 'rb' )
memory = list(struct.unpack( cells * 'i', f.read() ))
f.close()


sys.stdout.write("[ ")

for cell in memory:
   sys.stdout.write(str(cell) + " ")
sys.stdout.write(" ] 'retro' define")
print ""
print "&retro ngaro"

