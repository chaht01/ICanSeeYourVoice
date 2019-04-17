# 1. Show the "start" artboard, first.
flow = new FlowComponent
flow.backgroundColor = 'transparent'
flow.showNext(FullView_quick)

videoLayer = new VideoLayer
    video: "images/video/pick.mov"
    size: Screen

videoLayer.sendToBack()
videoLayer.player.autoplay = false

talkSession = null
playStart.on Events.Tap, (evnet, layer)->
	videoLayer.player.play()
	talkSession = initSession(talks, 500)
	playStart.ignoreEvents = true
	event.stopPropagation()
playStart.on Events.Pan, (evnet, layer)->
	playStart.ignoreEvents = true
	event.stopPropagation()
playStart.on Events.PanStart, (evnet, layer)->
	playStart.ignoreEvents = true
	event.stopPropagation()
playStart.on Events.PanEnd, (evnet, layer)->
	playStart.ignoreEvents = true
	event.stopPropagation()


#
balloonAuthors = ['차탁', '둘리', 'Shin ima Yn','Thoa Duy', '진륭', 'ajapanda', 'jjeow' ,'ki1238']
talks = ['동동이 귀엽다~~', 'What happend to her eyes?😥', 'cac chi danglam gj mavui tek vay', 'خير وش ذا الوقاحه توني ما فتحت تويتررررر عيييبببببب', '드림캐쳐 펌프 굿 재미있어여', '유혀니 눈 왜저럼?😜' ,'눈 뭐에여', '화면점 봐요', '와왕//', '본방이당', 'خلصوا؟❤️', '笨蛋裕賢😘']
mymsg = ['가현아 항상응원해💘', '타아이돌🚫언급금지', '반말, 욕설금지!😡']
chats = []
getChatFeed = (parentLayer, msgGroup, specialColor) ->
	lineHeight = 18
	msg = Utils.randomChoice(msgGroup)
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

	
placeChat = (msgGroup, specialColor) ->
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

initSession = (msgGroup, interval, specialColor) ->
	return setInterval (->
		placeChat(msgGroup, specialColor)
	), interval
# talkSession = initSession(talks, 200)


#

bg.states = 
	default:
		blur: 0
		options:
			time: 0.2
	backdrop:
		blur: 5
		options:
			time: 0.2
backdrop.states = 
	default:
		opacity: 0
		options:
			time: 0.2
	backdrop:
		opacity: 1
		options:
			time: 0.2
		
opts = [opt1, opt2, opt3]
faces = [face1, face2, face3, face4, face5, face6, face7]
labels = [label_pick, label_quickinput]


label_pick.states = 
	active:
		scale: 0.75
		opacity: 0.75
label_quickinput.states = 
	active:
		scale: 0.75
		opacity: 0.75
		
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
label_pick.stateSwitch('default')
label_quickinput.stateSwitch('default')
backdrop.stateSwitch('default')
bg.stateSwitch('default')

targetOps = null
selectedOpt = null

bg.on Events.TapStart, ->
	quick_menu.x = event.touchCenter.x - quick_menu.width/2
	quick_menu.y = event.touchCenter.y - quick_menu.height/2
	label_pick.stateSwitch('active')
	label_quickinput.stateSwitch('active')
	backdrop.animate(backdrop.states.backdrop)
	bg.animate(bg.states.backdrop)
	quick_menu.opacity = 1
FullView_quick.on Events.TapEnd, ->
	quick_menu.opacity = 0
	

editTimer = null;
toBeEdited = null;
animationTimer = null;
currFocused = null;
isEdited = false
initTimer = (opt) ->
	progress_container.opacity = 1
	progress_container.parent = opt
	progress_container.x = Align.center
	progress_container.y = -28
	tick = 0
	clearInterval(animationTimer)
	animationTimer = setInterval(->
		draw(tick)
		tick+= Math.PI*2/150
	,10)
	return setTimeout(->
		keyboard.animate(keyboard.states.active)
		isEdited = true
	,1500)

bg.on Events.Pan, (event, layer) ->
	dir = event.offset.y > 0
	targetOps = if dir then opts else faces
	optOffsetY = if dir then [50, quick_menu.height/2] else [70-quick_menu.height/2, -quick_menu.height/2+10]
	for opt in targetOps
		distY = Math.abs(event.offset.y)
		distX = if Math.abs(event.offset.x - (opt.x+ opt.width/2 - quick_menu.width/2)) <5 then 0 else Math.abs(event.offset.x - (opt.x+ opt.width/2 - quick_menu.width/2))*3
		opt.scale = Utils.modulate(distX, [0, 200], [1.6, 1], true)
		opt.opacity = Utils.modulate(distY, [0, quick_menu.height/2], [0, 1], true)
		opt.y = Utils.modulate(distY, [0, quick_menu.height/2], optOffsetY, true)
		
	targetLabel = if dir then label_quickinput else label_pick
	labelOffsetY = if dir then [195, 145] else [0, 35]

	for label in labels
		distY = Math.abs(event.offset.y)
		label.opacity = Utils.modulate(distY, [0, quick_menu.height/2], [0.75, 0], true)
		label.scale = Utils.modulate(distY, [0, quick_menu.height/2], [0.75, 0.5], true)
		targetLabel.scale = Utils.modulate(distY, [0, quick_menu.height/2], [0.75, 1], true)
		targetLabel.opacity = Utils.modulate(distY, [0, quick_menu.height/2], [0.75, 1], true)
		targetLabel.y = Utils.modulate(distY, [0, quick_menu.height/2], labelOffsetY, true)
	
	
	if dir
		if currFocused == null then currFocused = targetOps[0]
		for opt in targetOps
			if opt.scale > currFocused.scale
				currFocused = opt
		if currFocused.scale <=1.4 || (currFocused == opt3 && opt_plus.opacity ==1)
			toBeEdited = null
			currFocused = null
			clearInterval(editTimer)
			clearInterval(animationTimer)
			progress_container.opacity = 0
		else if currFocused.scale > 1.4
			if toBeEdited == null
				toBeEdited = currFocused
				editTimer = initTimer(currFocused)
			else if toBeEdited != currFocused
				clearInterval(editTimer)
				toBeEdited = currFocused
				editTimer = initTimer(currFocused)
	
#
progress_container.html = '<canvas id="counter" width="30" height="30"></canvas>'

counter = document.getElementById('counter')
ctx = counter.getContext('2d')
imd = null
circ = Math.PI * 2
quart = Math.PI / 2
ctx.beginPath()
ctx.strokeStyle = '#fff'
ctx.lineCap = 'square'
ctx.closePath()
ctx.fill()
ctx.lineWidth = 2.0
imd = ctx.getImageData(0, 0, 240, 240)

draw = (current) ->
  ctx.putImageData(imd, 0, 0)
  ctx.beginPath()
  ctx.arc(15, 15, counter.width/2-2, -quart, -quart+current, false)
  ctx.stroke()
  return

#


bg.on Events.PanEnd, (event, layer) ->
	quick_menu.opacity = 0
	selectedOpt = targetOps[0]
	clearInterval(editTimer)
	clearInterval(animationTimer)
	for opt in targetOps
		if opt.scale > selectedOpt.scale
			selectedOpt = opt

	for opt in opts
		opt.scale = 0.3
		opt.opacity = 0
		opt.y = 50
	for opt in faces
		opt.scale = 0.3
		opt.opacity = 0
		opt.y = 50
	
	if selectedOpt == opt3 && opt_plus.opacity == 1
		keyboard.animate(keyboard.states.active)
	else
		if opts.indexOf(selectedOpt) >-1
			clearInterval(talkSession)
			placeChat([mymsg[opts.indexOf(selectedOpt)]])
			talkSession = initSession(talks, 200)
		if !isEdited then backdrop.animate(backdrop.states.default)
		if !isEdited then bg.animate(bg.states.default)
	
	transferX = selectedOpt.x + selectedOpt.width/2 - quick_menu.width/2
	for opt in targetOps
		opt.x -= transferX
		
		
keyboard.on Events.Tap, ->
	new_keyword.opacity = 1
keyboard.on Events.TapStart, (event,layer)->
	event.stopPropagation()
keyboard.on Events.TapEnd, (event,layer)->
	event.stopPropagation()
keyboard.on Events.PanStart, (event,layer)->
	event.stopPropagation()
keyboard.on Events.Pan, (event,layer)->
	event.stopPropagation()
keyboard.on Events.PanEnd, (event,layer)->
	event.stopPropagation()

confirm_keyword.on Events.Tap, ->
	isEdited = false
	opt3_keyword.opacity = 1
	opt_plus.opacity = 0
	keyboard.animate(keyboard.states.default)
	backdrop.animate(backdrop.states.default)
	bg.animate(bg.states.default)
	clearInterval(talkSession)
	placeChat([mymsg[2]])
	talkSession = initSession(talks, 200)
	
	
#

