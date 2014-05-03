Text = null


class @TrainVision
	timer: null
	timerCB: []

	imgPath:
		bg: "img/bg_e233.jpg"

	SETTING_FPS: 30
	game: null

	BG_SIZE:
		w: 2048
		h: 1536
	
	STAGE_SIZE:
		w:0
		h:0

	ZOOM: 1
	
	label:
		station: null

	color:
		green: "#009245"

	station: []
	station_name: "tachikawa"

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
		@_initGame @STAGE_SIZE.w, @STAGE_SIZE.h
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
		@_initLabel()
		return

	_initGame: (w,h)=>
		@game = new Game w, h
		for k, v of @imgPath
			@game.preload v

		@game.fps = @SETTING_FPS
		@game.onload = @game_onload
		@game.start()
		# $("#enchant-stage")
		# 	.css("width": "10px")
		return

	scene: null

	_initLabel: (lang_flag)=>
		lang_flag = lang_flag || 0

		if !@scene	
			@scene = new Scene(@convSize 1000, @convSize 5000)
			@game.pushScene @scene
		if !@label.station
			@label.station = new Label(@station[lang_flag])
			@scene.addChild @label.station

		station = @label.station
		station.text = @station[lang_flag]
		station.textAlign = "center"
		station.color = @color.green
		fontsize = @convSize(300)

		# station.x = @convSize(520)
		# station.y = @convSize(130)
		station.width = @convSize 1000
		station.height = @convSize 400

		station.scaleX = station.scaleY = 1
		station._layer._element.style.letterSpacing = 'normal'


		if lang_flag == 0
			# Japanese
			@label.station.x = @convSize(520)
			@label.station.y = @convSize(130)

			if station.text.length >= 5
				# 文字がはみ出すのでサイズを調整
				station.width = @convSize 1500
				station.textAlign = "left"
				station.scaleX = station.text.length/8
				station.x = station.x - (station.x * station.text.length/10.5)
			if station.text.length == 4
				station.scaleX = 4/5
				station.x -= @convSize 75
			station.font = station._layer._element.style.font = "normal bold " + fontsize + "px iwata";
		else if lang_flag == 1
			# English
			# console.log station.text +  " " + @station_name + " " + @station_name.length
			station._layer._element.style.letterSpacing = '-3px'

			width = 1000
			x = 520
			y = 100
			scale = 1
			align = "center"
			if @station_name.length >= 9
				width = 1500
				scale = 0.65
				x = 280
				if @station_name == "kichijoji"
					scale = 0.9
					x = 270
			if @station_name == "musashi_sakai"
				width = 2500
				x = -7
				y = 140
				scale = 0.57
				fontsize = fontsize /1.23
				align = "left"
				station._layer._element.style.letterSpacing = 'normal'
			if @station_name.length >= 15
				width = 2500
				x = -7
				y = 140
				scale = 0.57
				fontsize = fontsize /1.25
				align = "left"
				if @station_name == "musashi_koganei"
					scale = 0.53
					x = -55
				if @station_name == "higashi_koganei"
					scale = 0.56
					x = -20
			
			station.font = "normal bold " + fontsize + "px Arial";
			station.width = @convSize width
			station.textAlign = align
			@label.station.x = @convSize x
			@label.station.y = @convSize y
			station.scaleX = scale

		else if lang_flag == 2
			# ひらがな
			width = 1500
			x = 280
			y = 140
			scale = 0.8
			align = "center"

			if @station[lang_flag].length >= 5
				x = 260
				scale = 0.6
				station._layer._element.style.letterSpacing = '-6px'
			if @station[lang_flag].length == 6
				x = 220
				scale = 0.55
			if @station[lang_flag].length == 7
				width = 2500
				scale = 0.6
				fontsize = fontsize / 1.15
				x = 25
				y = 150
				align = "left"
				station._layer._element.style.letterSpacing = '-10px'

			if @station[lang_flag].length >= 8
				width = 2500
				scale = 0.51
				fontsize = fontsize / 1.15
				x = -60
				y = 150
				align = "left"
				station._layer._element.style.letterSpacing = '-10px'




			station.width = @convSize width
			station.textAlign = align
			@label.station.x = @convSize x
			@label.station.y = @convSize y
			station.scaleX = scale

			station.font = station._layer._element.style.font = "normal bold " + fontsize + "px iwata";
		return 

	_initSize: =>
		width = $(window).width()
		height = $(window).height()
		# TrainVisonを4:3で固定するため、横の長さを縦の長さから計算します。
		if(height < width)
			# 横長の画面の場合
			@STAGE_SIZE.w = Math.floor($(window).height() * (4/3))
			@STAGE_SIZE.h = Math.floor $(window).height()
		else if(width < height)
			# 縦長の画面の場合
			@STAGE_SIZE.w = Math.floor $(window).width()
			@STAGE_SIZE.h = Math.floor $(window).width()  * (3/4)

		@ZOOM = @STAGE_SIZE.w / @BG_SIZE.w

		console.log "w: " + @STAGE_SIZE.w
		console.log "h: " + @STAGE_SIZE.h 

		return

	convSize:(size)=>
		return @ZOOM * size

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
				@set_station @station_key[@station_c++]

		# console.log "update main"
		@set_station 
		@_initLabel @_timerHookCount % 3
		@_timerHookCount++
		return

	updateSubPanel: =>
		# console.log "update sub"
		return

	_timerHookCount:0

	_timerHook: =>
		for i in @timerCB
			i._time = i._time | 1
			if i._time >= i.time
				i.cb()
				i._time = 0
			else
				i._time++
		return

		


