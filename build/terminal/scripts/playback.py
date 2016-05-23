#!/usr/bin/env python
#importing python standard lib
import time
import os
import sys
import glob
import pickle
import subprocess
import gc
import signal
import shutil
import urllib2,json
from multiprocessing import Process
#importing gateone lib
from gateone.applications.terminal.logviewer import get_log_metadata, render_html_playback
from gateone.applications.terminal.logviewer import render_log_frames
#importing tornado lib
from tornado.escape import json_encode, json_decode

#set default lang
os.environ['LANG'] = 'en_US.utf8'
os.environ['LC_ALL'] = 'en_US.utf8'

QUEUE_LOCATION="/opt/gateone/queue"
CURRENT_QUEUE = ""
QUEUE = []
def get_playback_details(name):
	global QUEUE
	with open(name, 'r') as f:
		object = pickle.load(f)
	return object

def write_playback():
	global CURRENT_QUEUE
	global QUEUE_LOCATION
	import datetime
	import urllib2,json,tornado.template
	new_file = CURRENT_QUEUE
	destination = QUEUE_LOCATION + "/out"
	pid = str(os.getpid())
	c_limit = subprocess.Popen(["cpulimit", "-p",pid,"-l","20"], stdout=subprocess.PIPE)
	playback_details = get_playback_details(new_file)
	playback_path = playback_details['storage_path']
	playback = ''
	duration = "0"
	try:
		time.sleep(10)
		try:
			metadata = get_log_metadata(playback_details['log_path'])
			start = int(metadata.get("start_date"))
			end = int(metadata.get("end_date"))
			start_time = datetime.datetime.fromtimestamp(start/1000)
			end_time = datetime.datetime.fromtimestamp(end/1000)
			duration = str(end_time - start_time)
		except Exception as e:
			pass

		playback = render_html_playback(playback_details['log_path'])
	except Exception as e:
		params = {
      "id" : playback_details['id'],
      "status":"failure"
    }
		print(e)
		pass
		
	if playback:
		#checks playback path is exists or not
		try:
			if not os.path.exists(playback_path):
				f = open(playback_path,'w',0)
				f.write(playback)
				f.flush()
				f.close()
				os.chmod(playback_path,0775)
			elif os.path.exists(playback_path):
				try:
					os.remove(playback_path)
					f = open(playback_path,'w',0)
					f.write(playback)
					f.flush()
					f.close()
					os.chmod(playback_path,0775)
				except Exception, e:
					print(e)
					pass
			params = {
				"id" : playback_details['id'],
				"status":"success",
				"duration" : duration
			}

			try:
				shutil.move(new_file, destination)
				CURRENT_QUEUE = ""
			except Exception:
				CURRENT_QUEUE = ""
				os.remove(new_file)
				pass

			#QUEUE.remove(new_file)
		except Exception:
			params = {
				"id" : playback_details['id'],
				"status":"failure"
			}
			pass

	try:
		request = urllib2.Request(playback_details['notify_url'])
		request.add_header('Content-Type','application/json;charset=UTF-8')
		request.add_header('Accept','application/json;charset=UTF-8')
		request.add_data(json.dumps(params))
		urllib2.urlopen(request)
	except urllib2.URLError, e:
		print(e)
		pass

	try:
		os.kill(int(c_limit.pid),signal.SIGTERM)
	except OSError, e:
		print(e)
		pass

def spawn_process():
	p = Process(target=write_playback)
	p.daemon = True
	p.start()
	gc.collect()

def check_file_change():
	global QUEUE
	global CURRENT_QUEUE
	queue_path = os.path.join(QUEUE_LOCATION)
	if os.path.exists(queue_path):
		if os.listdir(queue_path) == []:
			pass
		else:
			try:
				new_file = max(glob.iglob(queue_path+'/in/*.syclops'), key=os.path.getctime)
				if not CURRENT_QUEUE:
					CURRENT_QUEUE=new_file
					QUEUE.append(new_file)
					spawn_process()
					return "Current Queue:" + new_file

				if CURRENT_QUEUE != new_file:
					CURRENT_QUEUE=new_file
					QUEUE.append(new_file)
					spawn_process()
					return "Current Queue:" + CURRENT_QUEUE
			except Exception, e:
				pass
	else:
		os.makedirs(QUEUE_LOCATION)
		os.mkdir(QUEUE_LOCATION+"/in")
		os.mkdir(QUEUE_LOCATION+"/out")
		print("The {path} directory is created to store queue data.".format(path=QUEUE_LOCATION))

if __name__ == "__main__":
	try:
		print("Application has been started")
		while 1:
			c_file = check_file_change()
			if c_file:
				print(c_file)
			time.sleep(0.4)
	except KeyboardInterrupt, e:
		print("\nApplication has been closed.")
		sys.exit(0)
