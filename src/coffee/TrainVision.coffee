###
Chuo Line E233 TrainVision

main class

Copyright (c) 2014 Koutarou Yabe

This software is released under the MIT License.

http://opensource.org/licenses/mit-license.php
###

Text = null

class @TrainVision
	timer: null
	timerCB: []

	SETTING_FPS: 30
	game: null

	BG_SIZE:
		w: 2048
		h: 1536
	
	STAGE_SIZE:
		w:0
		h:0

	ZOOM: 1

	isFirefox: 0
	
	label:
		station: null
		main_parts:
			next: null
			next_is: null
			num_text: null
			num: null
			time_text: null
			time: null
	scene:
		station: null
		main: null

	color:
		green: "#009245"

	station: []
	station_name: "tachikawa"

	train:
		car_num: 13
		go: "東京行"

	station_key: []

	init: =>
		get = window.getRequest()
		Text = new window.Text
		for k, v of Text.station
			@station_key.push k

		if(get.station)
			@set_station get.station
		else
			@set_station "tachikawa"

		@_initSize()
		@_initGame @BG_SIZE.w, @BG_SIZE.h
		if !timer
			timer = setInterval @_timerHook, 1000
		@setTimerConf()
		return

	set_station:(station_name)=>
		@station_name = station_name
		@station = Text.station[@station_name]
		if(!@station)
			@station = Text.station["tachikawa"]

	game_onload: =>
		@initMainPanel 0
		return

	_initGame: (w,h)=>
		@game = new Game w, h
		@game.scale = @ZOOM
		for k, v of @imgPath
			@game.preload v

		@game.fps = @SETTING_FPS
		@game.onload = @game_onload
		@game.start()
		return

	initMainPanel: (lang_flag)=>
		lang_flag = lang_flag || 0
		if !@scene.main	
			@scene.main = new Scene
			@game.pushScene @scene.main

		if !@scene.station
			@scene.station = new Scene
			@game.pushScene @scene.station

		@set_station_label lang_flag
		@set_main_panel lang_flag

	set_station_label: (lang_flag)=>
		# lang_flag = 1
		if !@label.station
			@label.station = new Label(@station[lang_flag])
			@scene.station.addChild @label.station

		station = @label.station
		station.text = @station[lang_flag]
		station.textAlign = "center"
		station.color = @color.green
		fontsize = 300

		station.width = 1000
		station.height = 400

		station.scaleX = station.scaleY = 1
		station._layer._element.style.letterSpacing = 'normal'


		if lang_flag == 0
			# Japanese
			@label.station.x = 520
			@label.station.y = 130

			if station.text.length >= 5
				# 文字がはみ出すのでサイズを調整
				station.width = 1500
				station.textAlign = "left"
				station.scaleX = station.text.length/8
				station.x = station.x - (station.x * station.text.length/10.5)
			if station.text.length == 4
				station.scaleX = 4/5
				station.x -= 75
			station.font = station._layer._element.style.font = "normal bold " + fontsize + "px iwata";
		else if lang_flag == 1
			# English
			# console.log station.text +  " " + @station_name + " " + @station_name.length
			station._layer._element.style.letterSpacing = '-3px'

			width = 1000
			x = 520
			y = 120
			scale = 1
			align = "center"
			if @station_name == "mitaka"
				y = 150
			if @station_name == "tachikawa" or @station_name == "kunitachi"
				y = 150
				width = 3000
			if @station_name.length >= 9
				width = 1500
				scale = 0.65
				x = 270
				y = 100
				if @station_name == "kichijoji"
					scale = 0.8
					x = 270
			if @station_name == "musashi_sakai"
				width = 2500
				x = -125
				y = 160
				scale = 0.47
				# fontsize = fontsize
				align = "left"
				station._layer._element.style.letterSpacing = 'normal'
			if @station_name.length >= 15
				width = 2500
				x = -7
				y = 160
				scale = 0.57
				fontsize = fontsize /1.25
				align = "left"
				if @station_name == "nishi_kokubunji"
					scale = 0.53
					x = -48
				if @station_name == "musashi_koganei"
					scale = 0.50
					x = -100
				if @station_name == "higashi_koganei"
					scale = 0.52
					x = -70
			
			station.font = "normal bold " + fontsize + "px Arial";
			station.width = width
			station.textAlign = align
			@label.station.x = x
			y += 30 if @isFirefox
			@label.station.y = y 
			station.scaleX = scale

		else if lang_flag == 2
			# ひらがな
			width = 2500
			x = -220
			y = 140
			scale = 0.8
			align = "center"

			if @station[lang_flag].length >= 5
				scale = 0.6
			if @station[lang_flag].length == 6
				scale = 0.55
			else if @station[lang_flag].length == 7
				scale = 0.46
			else if @station[lang_flag].length == 8
				scale = 0.3

			station.width = width
			station.textAlign = align
			@label.station.x = x
			@label.station.y = y
			station.scaleX = scale

			station.font = station._layer._element.style.font = "normal bold " + fontsize + "px iwata";
		return

	set_main_panel: (lang_flag)=>
		if lang_flag isnt 1 then lang_flag = 0
		l = {}
		time = new Date()
		for k, v of @label.main_parts
			if not @label.main_parts[k]
				@label.main_parts[k] = new Label()
				@scene.station.addChild @label.main_parts[k]
			l[k] = @label.main_parts[k]
			l[k].width = 500
			l[k].text = Text[k][lang_flag]
			l[k].textAlign = "right"	

		l.time_text.textAlign = "center"
		
		l.num.text = @train.car_num
		l.num.textAlign = "center"
		l.num.font = "normal bold 135px Arial"
		l.num.x = 1685
		l.num.y = 35

		toDoubleDigits = (num)->
			num += ""
			if num.length is 1 then num = "0" + num
			num

		l.time.text = toDoubleDigits(time.getHours()) + ":" + toDoubleDigits(time.getMinutes())
		l.time.font = "normal bold 90px Arial"
		l.time.x = 1505
		l.time.y = 350
		l.time.y += 10 if @isFirefox
		# l.time._layer._element.style.letterSpacing = "0px"

		if lang_flag == 1
			# English
			l.next.x = 15
			l.next.y = 300
			l.next.font = "normal normal 120px Arial"

			l.num_text.x = 1350
			l.num_text.y = 30
			l.num_text.font = "normal normal 60px Arial"

			l.time_text.x = 1640
			l.time_text.y = 300
			l.time_text.font = "normal normal 55px Arial"
		else
			# Japanese
			l.next.font = "normal bold 120px iwata"
			l.next.x = 15
			l.next.y = 335

			l.next_is.font = "normal bold 120px iwata"
			l.next_is.x = 1260
			l.next_is.y = 335
			
			l.num_text.x = 1515
			l.num_text.y = 195
			l.num_text.font = "normal bold 59px iwata"

			l.time_text.x = 1640
			l.time_text.y = 285
			l.time_text.font = "normal bold 60px iwata"


	_initSize: =>
		width = $(window).width()
		height = $(window).height()

		# TrainVisonを4:3で固定するため、横の長さを縦の長さから計算します。
		if(height < width)
			# 横長の画面の場合
			@STAGE_SIZE.w = Math.floor(height * (4/3))
			# @STAGE_SIZE.h = Math.floor $(window).height()
		else if(width < height)
			# 縦長の画面の場合
			@STAGE_SIZE.w = Math.floor width
			# @STAGE_SIZE.h = Math.floor $(window).width()  * (3/4)

		@ZOOM = @STAGE_SIZE.w / @BG_SIZE.w

		if window.navigator.userAgent.toLowerCase().indexOf("firefox") isnt -1
			@isFirefox = 1

		return

	convSize:(size)=>
		return size

	# Āā Īī Ūū Ēē Ōō

	setTimerConf: =>
		@timerCB = [
			{
				name: "main"
				time: 3
				cb: @updateMainPanel
			},
			{
				name: "sub"
				time: 6
				cb: @updateSubPanel
			}
		]
		return


	station_c:0
	flag: 1
	updateMainPanel: =>
		if @flag
			if @station_key.length <= @station_c
				@station_c = 0
			if @_timerHookCount % 3 == 0
				# @set_station @station_key[@station_c++]
				console.log ""
		# @set_station @station_key[@station_c++]

		console.log "update main panel"
		@set_station 
		@initMainPanel @_timerHookCount % 3
		@_timerHookCount++
		return

	updateSubPanel: =>
		# console.log "update sub"
		return

	_timerHookCount:0

	_timerHook: =>
		console.log "timer"
		for i in @timerCB
			i._time = i._time | 1
			if i._time >= i.time
				i.cb()
				i._time = 0
			else
				i._time++
		return

		


