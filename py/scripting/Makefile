default: buildpre buildika

buildpre:
	cd pre && cp ../../parable.py .
	cd pre && cp ../../stdlib.p .
	cd pre && python convert.py > pre
	cd pre && chmod +x pre
	cd pre && mv pre ../..
	cd pre && rm -f parable.py stdlib.p *.pyc

buildika:
	cd ika && cp ../../parable.py .
	cd ika && cp ../../stdlib.p .
	cd ika && python convert.py > ika
	cd ika && chmod +x ika
	cd ika && mv ika ../..
	cd ika && rm -f parable.py stdlib.p *.pyc
