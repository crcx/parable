default: buildpre buildallegory

buildpre:
	cd pre && cp ../../parable.py .
	cd pre && cp ../../stdlib.p .
	cd pre && python convert.py > pre
	cd pre && chmod +x pre
	cd pre && mv pre ../..
	cd pre && rm -f parable.py stdlib.p *.pyc

buildallegory:
	cd allegory && make
	mv allegory/allegory ../
