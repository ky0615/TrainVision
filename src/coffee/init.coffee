###
Chuo Line E233 TrainVision

init file

Copyright (c) 2014 Koutarou Yabe

This software is released under the MIT License.

http://opensource.org/licenses/mit-license.php
###

enchant()

TrainVision = null
m_timer = null
s_timer = null

stationFile = [
	"Text"
]

window.getRequest = ->
	if location.search.length > 1
		get = new Object()
		console.log location.search
		ret = location.search.substr(1).split('&')
		for k, v of ret
			r = ret[k].split("=")
			get[r[0]] = r[1]
		return get
	else
		return false

window.onload = =>
	

	for k, v of stationFile
		$.getScript "src/js/" + v + ".js", =>
			console.log "success"
			init()

	return

init = =>
 	TrainVision = new window.TrainVision
 	TrainVision.init()
 	return
