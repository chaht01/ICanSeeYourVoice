videoLayer = new VideoLayer
    video: "images/video/balloon.mov"
    size: Screen

videoLayer.sendToBack()
videoLayer.player.autoplay = false

talkSession = null
videoLayer.on Events.Tap, (evnet, layer)->
	videoLayer.player.play()
	talkSession = initSession(talks, 500)
	videoLayer.ignoreEvents = true

balloonAuthors = ['차탁', '둘리', 'Shin ima Yn','Thoa Duy', '진륭', 'ajapanda', 'jjeow' ,'ki1238']
talks = ['동동이 귀엽다~~', 'What happend to her eyes?😥', 'cac chi danglam gj mavui tek vay', 'خير وش ذا الوقاحه توني ما فتحت تويتررررر عيييبببببب', '드림캐쳐 펌프 굿 재미있어여', '유혀니 눈 왜저럼?😜' ,'눈 뭐에여', '화면점 봐요', '와왕//', '본방이당', 'خلصوا؟❤️', '笨蛋裕賢😘']
mymsg = ['가현아 항상응원해💘', '타아이돌🚫언급금지', '반말, 욕설금지!😡', '드림캐쳐 언니들 팬미팅 언제 하는지 알아요 님들?? 공홈에는 안나와 있던데...']
balloonmsg = ['가현아 항상응원해💘', '타아이돌🚫언급금지', '반말, 욕설금지!😡', '드림캐쳐 언니들 팬미팅<br> 언제 하는지 알아요 님들??<br> 공홈에는 안나와 있던데...']

chats = []
getChatFeed = (opt) ->
	lineHeight = if opt.large then 30 else 18
	fontSize = if opt.large then 25 else 14
	fontWeight = if opt.large then 'bold' else 'regular'
	
	msg = Utils.randomChoice(opt.msgGroup)
	if opt.specialColor == undefined
		opt.specialColor = '#fff'
	chatBallonLayer = new Layer
		width: Screen.width - 50
		x: 0
		height: msg.split('<br>').length * lineHeight + 34
		backgroundColor: 'transparent'
		parent: opt.parentLayer
	chatBallonLayer.html = 
		'<div style="display:inline-block;position:relative;padding: 3px 20px 6px 8px; background-color:rgba(0,0,0,.2);border-radius:4px;margin-bottom:6px;">'\
		+'<div style="font-size:12px;margin:0;line-height:22px;color:'+'#12CFFF;'+'">'+Utils.randomChoice(balloonAuthors)+'</div>'\
		+'<div style="position:relative; color:'+opt.specialColor+'; font-size:'+fontSize+'px; line-height: '+lineHeight+'px; font-weight:'+fontWeight+'">'\
		+ msg ? msg\
		+'</div>'\
		+'</div>'	
		
	return chatBallonLayer


	
placeChat = (opt) ->
	opt.parentLayer = chat_container
	chatLayer = getChatFeed(opt)
	chatLayer.y = if chats[chats.length-1] then chats[chats.length-1].y + chats[chats.length-1].height else 0
	chats.push(chatLayer)
	if chatLayer.y + chatLayer.height > chat_container.height
		offset = chat_container.height - (chatLayer.y + chatLayer.height)
		for chat in chats
			chat.y += offset
		if Math.abs(chats[0].y) > chats[0].height
			tobeDelete = chats.shift()
			tobeDelete.destroy()

initSession = (msgGroup, interval, specialColor) ->
	return setInterval (->
		opt = 
			msgGroup: msgGroup
			specialColor: specialColor
		placeChat(opt)
	), interval


#

keyboard.states = 
	default:
		y: 375
		opacity: 0
		options:
			time: 0.5
	active:
		y: 166
		opacity: 1
		options:
			time: 0.5

chat_container.states = 
	default:
		y: 96
		options:
			time: 0.5
	active:
		y: -63
		options:
			time: 0.5	
			
keyboard.stateSwitch('default')
chat_container.stateSwitch('default')
trigger_chat.on Events.Tap, ->
	keyboard.animate(keyboard.states.active)
	chat_container.animate(chat_container.states.active)

input_wrapper.originX = 0
inputText = null
cycler = Utils.cycle(mymsg)
input_wrapper.on Events.Tap, ->		
	inputText = new TextLayer
		text: cycler()
		parent: input_wrapper
		color: '#434343'
		fontSize: 16
		y: Align.center
		x: 0
		rotation: 0
	inputText.states = 
		default:
			rotation: 0
			options:
				time: 0.2	
				
keyboard_expand_field.states = 
	default:
		height: 10
		options:
			time: 0.2	


expandTimer = null
confirm_keyword.on Events.LongPressStart, (event)->
	if inputText.text.length>12
		
	else
		expandTimer = initExpandAnimation()	

confirm_keyword.on Events.LongPressEnd, (event)->
	opt = 
		msgGroup: [balloonmsg[mymsg.indexOf(inputText.text)]]
		large: if inputText.text.length<=11 then true else false
	clearInterval(expandTimer)
	inputText.animate(inputText.states.default)
	inputText.destroy()
	keyboard_expand_field.animate(keyboard_expand_field.states.default)
	keyboard.animate(keyboard.states.default)
	chat_container.animate(chat_container.states.default)
	clearInterval(talkSession)
	input_wrapper.scale = 1
	placeChat(opt)
	talkSession = initSession(talks, 500)

initExpandAnimation = () ->
	tick = 0
	timer = setInterval( ->
		input_wrapper.scale	+= (1/1000000)*Math.pow(tick, 2)
		keyboard_expand_field.height = 10 + (1/3000)*Math.pow(tick, 2)
		inputText.rotation = (1/5000)*Math.pow(tick, 2)*Math.sin(tick)
		tick++;
	, 10)
	if inputText.scale > 2
		clearInterval(timer)
	return timer