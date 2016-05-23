#!/bin/bash
if [[ ! -f '/usr/local/bin/gateone' ]];then
	cd /gateone
	#install gateone
	python setup.py install
	# installs gateone requiered pacakge
	pip install html5lib==1.0b3 slimit==0.8.1 cssmin==0.2.0 PIL pyopenssl cffi tornado==3.1.1
	#create api keys
	/usr/local/bin/gateone --new_api_key
fi
