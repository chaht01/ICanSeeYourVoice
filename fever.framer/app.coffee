# video layer 
videoLayer = new VideoLayer
    video: "images/video/fever_bg_cropped.mov"
    size: Screen
    parent: crop_range

alphaLayer = new VideoLayer
    video: "images/video/Fever_alpha_1.mov"
    size: Screen

alphaLayer.sendToBack()
videoLayer.sendToBack()
alphaLayer.player.autoplay = false
videoLayer.player.autoplay = false
		
videoLayer.on Events.Tap, (event, layer)->
	layer.player.play()
	initPlayer()
	layer.ignoreEvents = true

videoLayer.states = 
	crop1:
		y: -7
	crop2:
		y: -7
		x: -7
crop_range.states = 
	crop1:
		height: Screen.height - 7
		y: 7
	crop2:
		width: Screen.width - 14
		height: Screen.height - 14
		y: 7
		x: 7


balloonAuthors = ['차탁', '둘리', 'Shin ima Yn']
talks = ['YOU 불러주세요 ㅠㅠ', '헐 지금 라이브임??', '예뻐요', '처음부터 너와나!<br>제발요 ㅠㅠ', '헐', '처음부터너와나', '헐대박', '무반주??', '직접보고싶다ㅠㅠㅠ', '언니존예', 'ㅠㅠㅠㅠㅠㅠㅠ']
lyrics = ['내안의 빛이 되어줘💛','나의 맘을 알아줘💛','내 세상의💛', '밝은 별이 되어줘💛','후회하지 않을게💛','너의 이유 되줄게💛', '처음부터 너와 나인 것처럼💛', 'Love you💛']
lyricsInterval = [0, 2500, 2500, 1500, 3000, 2500, 2500, 4000]

chats = []
getChatFeed = (parentLayer, msgGroup, specialColor) ->
	lineHeight = 18
	msg = Utils.randomChoice(msgGroup)
	if specialColor != undefined
		msg = '💛'+msg
	if specialColor == undefined
		specialColor = '#fff'
	chatBallonLayer = new Layer
		width: Screen.width - 50
		x: 0
		height: msg.split('<br>').length * lineHeight + 34
		backgroundColor: 'transparent'
		parent: parentLayer
	chatBallonLayer.html = 
		'<div style="display:inline-block;position:relative;padding: 3px 20px 6px 8px; background-color:rgba(0,0,0,.2);border-radius:4px;margin-bottom:6px;">'\
		+'<div style="font-size:12px;margin:0;line-height:22px;color:'+'#12CFFF;'+'">'+Utils.randomChoice(balloonAuthors)+'</div>'\
		+'<div style="position:relative; color:'+specialColor+'; font-size:14px; line-height: '+lineHeight+'px;">'\
		+ msg ? msg\
		+'</div>'\
		+'</div>'	
		
	return chatBallonLayer

	

initSession = (msgGroup, interval, specialColor) ->
	return setInterval (->
		chatLayer = getChatFeed(chat_container, msgGroup, specialColor)
		chatLayer.y = if chats[chats.length-1] then chats[chats.length-1].y + chats[chats.length-1].height else 0
		chats.push(chatLayer)
		if chatLayer.y + chatLayer.height > chat_container.height
			offset = chat_container.height - (chatLayer.y + chatLayer.height)
			for chat in chats
				chat.y += offset
			if Math.abs(chats[0].y) > chats[0].height
				tobeDelete = chats.shift()
				tobeDelete.destroy()
	), interval

initLyricSession = () ->
	for lyric, i in lyrics
		((text)->
			self = text
			delay = 0
			for j in [0...i+1]
				delay += lyricsInterval[j]
			setTimeout( -> 
				if fever_input.children[0] then fever_input.children[0].destroy()
				lyricText = new TextLayer
					text: self.substr(0, self.length-2)
					parent: fever_input
					color: '#F8E81C'
					fontSize: 15
					y: Align.center
					x: Align.center
			, delay)	
		) lyric

initPlayer = () ->
	talkSession = initSession(talks, 200)
	setTimeout( ->
		chat_input.opacity = 0
		fever_input.opacity = 1
		initLyricSession()
		alphaLayer.player.play()
		crop_range.stateSwitch('crop1')
		videoLayer.stateSwitch('crop1')
		setTimeout(->
			crop_range.stateSwitch('crop2')
			videoLayer.stateSwitch('crop2')
		,3000)
		for lyric, i in lyrics
			((text)->
				selfGroup = [text]
				delay = 0
				for j in [0...i+1]
					delay += lyricsInterval[j]
				setTimeout(->
					clearInterval(talkSession)
					talkSession = initSession(selfGroup, 100, '#F8E81C')
				,delay)
			) lyric
	, 13500)
	