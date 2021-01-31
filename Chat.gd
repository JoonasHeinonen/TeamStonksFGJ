extends Control

signal intro_ended
signal intermission_ended

# Define base variables
var playerName = null
var playerReplies = [
	"All right! This should be the file!", "Here you go.", "Okay! Hope this is what you're looking for!"
]
var level = 0
onready var chat_font = preload("res://gfx/fonts/PaytoneOne.ttf")
onready var LevelLabel = get_node("ChatTextRect/LevelContainer/LevelLabel")
onready var PlayerMessage = get_node("ChatTextRect/PlayerMessageContainer/PlayerMessage")
onready var audio = get_node("AudioStreamPlayer")

var kari = load("res://gfx/portraits/icon_kari.png")
var matti = load("res://gfx/portraits/icon_matti.png")
var minna = load("res://gfx/portraits/icon_minna.png")
var petri = load("res://gfx/portraits/icon_petri.png")
var hanna = load("res://gfx/portraits/icon_hanna.png")
var liisa = load("res://gfx/portraits/icon_liisa.png")
var erkki = load("res://gfx/portraits/eero.png")
var kalle = load("res://gfx/portraits/kalle.png")
var sara = load("res://gfx/portraits/sara.png")
var risto = load("res://gfx/portraits/Risto.png")


var icon_map = {
	"Kari": kari,
	"Matti": matti,
	"Minna": minna,
	"Petri": petri,
	"Hanna": hanna,
	"Liisa": liisa,
	"Kalle": kalle,
	"Erkki": erkki,
	"Risto": risto,
	"Sara": sara
}

# Define mission briefings and banter

# Banter per person
var banter = {
	"Petri": [
		"I’m telling you; this is going to buy as a promotion for sure.",
		"We worked overtime all week for this.",
		"Remember who did the hard work: this guy.",
		"This is going to look so good on my CV."
	],
	"Minna": [
		"I’m really proud of you all for pulling this off.",
		"I hope I wasn’t too harsh with you all.",
		"Good work team, good work.",
		"Well, it took many late evenings, but we pulled it off."
	],
	"Kari": [
		"So, are we getting overtime pay for this?",
		"I need to check something real quick.",
		"I’m going to grab some more water.",
		"I hope this was worth all the extra effort."
	],
	"Matti": [
		"Thanks for helping me with the project, it was a lot to take in so soon.",
		"I think I might’ve left a few mistakes in my segment...",
		"I was so sure we’d fail with this.",
		"This is hell of  a thing to start your first week with."
	],
	"Hanna": [
		"Has everyone had a proper breakfast today?",
		"Did you all have a nice weekend?",
		"My webcam is flashing, should it be doing that?",
		"Isn’t your birthday coming up Matti? I’ll make you a cake."
	],
}

# Late banter

# Failure banter
var late_banter = {
	"Petri": [
		"Hey, what’s taking so long?",
		"I hope you haven’t lost my work MC."
	],
	"Risto": [
		
	],
	"Sara": [],
	"Erkki": [],
	"Liisa": [],
	"Minna": [
		"I’m sure she has the files for us soon. Right?",
		"Um… Does anyone else have copies of the files?"
	],
	"Kalle": [],
	"Kari": [
		"Damn, looks like the meeting is going to take longer than it was supposed to.",
		"Hey, we don’t have all day here. Just send the files."
	],
	"Matti": [
		"Did you find it all MC? I did send my stuff to you, right?",
		"I’d help with searching the files, but she’s my senior, so..."
	],
	"Hanna": [
		"Do you need any help looking?",
		"Is everything alright MC?"
	],
}

# Mission one
var briefingOne = [
	{
		"sender": "Liisa",
		"message": "Alright, did you have the new project ready? I don’t want to spend too much time on this."
	},
	{
		"sender": "Kari",
		"message": "Yeah, sure. We got it all figured out. "
	},
	{
		"sender": "Liisa",
		"message": "Let’s hear it then, so we can get this meeting done as fast as possible."
	},
	{
		"sender": "Hanna",
		"message": "Of course. MC has the presentation, right?"
	},
]
var briefingTwo = [
	{
		"sender": "Kalle",
		"message": "I heard you had something interesting for me? You know, something to impress the big shots with."
	},
	{
		"sender": "Kari",
		"message": "Uh, sure. I mean, probably."
	},
	{
		"sender": "Kalle",
		"message": "Less mumbling, more hustling. Where’s the presentation?"
	},
	{
		"sender": "Petri",
		"message": "MC has the graphs we made. Come on, share them with us."
	},
]
var briefingThree = [
	{
		"sender": "Risto",
		"message": "Man, I love when people have propositions like this. Love the enthusiasm, love the vibe!"
	},
	{
		"sender": "Petri",
		"message": "I got you. This has some great synergy in it."
	},
	{
		"sender": "Risto",
		"message": "Fantastic. Well, let’s take a look. No pressure, just talk me through it."
	},
	{
		"sender": "Kari",
		"message": "Alright. MC, can you share the notes with us?"
	},
]
var briefingFour = [
	{
		"sender": "Sara",
		"message": "Good morning. You have 12 minutes reserved for your proposal. No more, no less."
	},
	{
		"sender": "Minna",
		"message": "Of course. It will be worth your time."
	},
	{
		"sender": "Sara",
		"message": "It better be, my time is precious. So, I assume you have the projection and analytics ready?"
	},
	{
		"sender": "Petri",
		"message": "Absolutely. MC, show them to her."
	},
]
var briefingFive = [
	{
		"sender": "Erkki",
		"message": "Mph! You have some project for me to see? A lucrative one, I assume?"
	},
	{
		"sender": "Matti",
		"message": "Oh yeah, very much so."
	},
	{
		"sender": "Erkki",
		"message": "Good, good! I didn’t build this company by just throwing money around."
	},
	{
		"sender": "Erkki",
		"message": "Well, what is it?!"
	},
	{
		"sender": "Minna",
		"message": "MC has the video, right?"
	},
]

# Mission one ending
var briefingOneEnd = [
	{
		"goodEnding": [
			{
				"sender": "Liisa",
				"message": "Hmm. It’s decent enough. We can put this forward. But if something goes wrong, it’s not my fault."
			},
			{
				"sender": "Matti",
				"message": "Oh, really? Thanks."
			},
			{
				"sender": "Liisa",
				"message": "Meeting’s over. Thank God."
			},	
		],
		"badEnding": [
			{
				"sender": "Liisa",
				"message": "You really don’t have this figured out yet? And now you’ve just wasted my time."
			},
			{
				"sender": "Hanna",
				"message": "It’ll just take a bit longer, I’m sure she has it."
			},
			{
				"sender": "Liisa",
				"message": "I need a coffee. If I don’t come back, you can leave as well."
			},
			{
				"sender": "Liisa",
				"message": "Be better prepared next time."
			},	
		]
	}		
]
# Mission one ending
var briefingFiveEnd = [
	{
		"goodEnding": [
			{
				"sender": "Erkki",
				"message": "Hahahhah! Excellent, we will make so much money out of this!"
			},
			{
				"sender": "Minna",
				"message": "Thank you, we worked hard to get it done."
			},
			{
				"sender": "Erkki",
				"message": "You’re bright ones, I can see that. We can’t let that talent get wasted."
			},
			{
				"sender": "Erkki",
				"message": "Take this project to the finish line and I’ll have a promotion for each one of you. And a big fat raise as well, of course!"
			},	
		],
		"badEnding": [
			{
				"sender": "Erkki",
				"message": "What is this? Why am I still waiting?!"
			},
			{
				"sender": "Kari",
				"message": "Just a moment, just a moment…"
			},
			{
				"sender": "Erkki",
				"message": "Ah! You youngsters don’t know what it’s all about! Time is money!"
			},
			{
				"sender": "Erkki",
				"message": "Is this how you’re handling your usual work as well? Seems like we might be paying you too much, I must look into that…"
			},	
		]
	}		
]
# Mission one ending
var briefingTwoEnd = [
	{
		"goodEnding": [
			{
				"sender": "Kalle",
				"message": "Hey, this is some hot stuff! I’ll definitely be sending this forward."
			},
			{
				"sender": "Hanna",
				"message": "Thank you. It was a team effort, really."
			},
			{
				"sender": "Kalle",
				"message": "This will definitely help me… I mean us, with greasing some corporate wheels."
			},	
		],
		"badEnding": [
			{
				"sender": "Kalle",
				"message": "Come on, come on! I don’t have all day!"
			},
			{
				"sender": "Minna",
				"message": "These are worth the wait, I promise."
			},
			{
				"sender": "Kalle",
				"message": "Time’s running out… Forget it, I have other meetings to attend to."
			},
			{
				"sender": "Kalle",
				"message": "If I’m late, you can bet it’s you who’ll take the blame."
			},	
		]
	}		
]
# Mission one ending
var briefingThreeEnd = [
	{
		"goodEnding": [
			{
				"sender": "Risto",
				"message": "Man oh man, you folks are killing it! This is totally outside of the box!"
			},
			{
				"sender": "Petri",
				"message": "That’s exactly what we were going for!"
			},
			{
				"sender": "Risto",
				"message": "I’m gonna send this straight to the big shots. Really proud of you all, you’re exactly the type of people this corporation needs!"
			},	
		],
		"badEnding": [
			{
				"sender": "Risto",
				"message": "Mmnh… I’m not feeling the vibes right now. That’s a bummer."
			},
			{
				"sender": "Hanna",
				"message": "Should we take a little break while we wait?"
			},
			{
				"sender": "Risto",
				"message": "No, see… You gotta have more enthusiasm about this! You can’t just mess it up so easily."
			},
			{
				"sender": "Risto",
				"message": "I gotta turn this down. If you want to impress the big shots, you need better energy than this"
			},	
		]
	}		
]
# Mission one ending
var briefingFourEnd = [
	{
		"goodEnding": [
			{
				"sender": "Sara",
				"message": "The numbers look good enough. Solid research, good market-penetration."
			},
			{
				"sender": "Matti",
				"message": "…Thank… you?"
			},
			{
				"sender": "Sara",
				"message": "I’ll let the CEO know about this. We can use this on next quarter’s strategy. The marketing department needs to be brought on board as well."
			},	
		],
		"badEnding": [
			{
				"sender": "Sara",
				"message": "No numbers, then?"
			},
			{
				"sender": "Petri",
				"message": "We have them, trust us."
			},
			{
				"sender": "Sara",
				"message": "You’ve already wasted the most important one: my time."
			},
			{
				"sender": "Sara",
				"message": "I think we’re done here. If you have no respect for me, I doubt you’d handle other resources with better care."
			},	
		]
	}		
]

# Define other needed variables for technical reasons, e.g. random numbers
var rng = RandomNumberGenerator.new()
var delay = 2
var timer = 0
var current_intro_message = 0
var current_intermission_message = 0
var is_intro = false
var is_ending = false
var is_game_on = false
var is_intermission = false
var is_bad_ending = false
var possible_participants = []
var current_briefing = briefingOne
var end_briefing = briefingOneEnd

# Setter functions
func setLevel(lvl):
	level = lvl
	print("Current level is: ", level)
	
func set_meeting_number(level):
	get_node("ChatTextRect/LevelContainer/LevelLabel").text = "Project Meeting " + str(level)

func _determine_level(level):
	print(level)
	if level == 1:
		return briefingOne
	if level == 2:
		return briefingTwo
	if level == 3:
		return briefingThree
	if level == 4:
		return briefingFour
	if level == 5:
		return briefingFive
		
func _determine_end_briefing(level):
	if level == 1:
		return briefingOneEnd
	if level == 2:
		return briefingTwoEnd
	if level == 3:
		return briefingThreeEnd
	if level == 4:
		return briefingFourEnd
	if level == 5:
		return briefingFiveEnd

func set_intro(level):
	timer = 0
	var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
	is_intro = true
	is_game_on = false
	for child in chat_msg_container.get_children():
		child.queue_free()
	current_intro_message = 0
	current_intermission_message = 0
	current_briefing = _determine_level(level)
	end_briefing = _determine_end_briefing(level)
	determine_possible_participants()
	set_meeting_number(level)
	print("new intro set")
	
func start_intermission(game_over):
	is_bad_ending = game_over
	is_intermission = true
	is_intro = false
	is_game_on = false

func determine_possible_participants():
	for p in current_briefing:
		if p["sender"] in banter:
			possible_participants.append(p["sender"])

func _process(delta):
	
	if is_intro:
		var intro_length = len(current_briefing)
		timer += 1 * delta
		if timer > delay:
			if current_intro_message > len(current_briefing) - 1:
				is_intro = false
				emit_signal("intro_ended")
				is_game_on = true
			else:
				var m = current_briefing[current_intro_message]
				var msg = m.sender + "\n" + m.message + "\n"
				
				var new_msg_container = HSplitContainer.new()
				var new_msg_label = Label.new()
				var new_msg_icon = TextureRect.new()
				
				new_msg_icon.texture = icon_map[m.sender]
				new_msg_label.text = msg
				new_msg_label.margin_right = 330
				new_msg_icon.margin_right = 100
				new_msg_label.autowrap = true
				
				var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
				chat_msg_container.add_child(new_msg_container)
				new_msg_container.add_child(new_msg_icon)
				new_msg_container.add_child(new_msg_label)
				chat_msg_container.margin_right = 330
				audio.play()
				
				timer = 0
				current_intro_message += 1
	elif is_intermission:
		timer += 1 * delta
		if timer > delay:
			if is_bad_ending:
				var intermission_length = len(end_briefing[0]["badEnding"])
				if current_intermission_message > len(end_briefing[0]["badEnding"]) - 1:
					is_intermission = false
					emit_signal("intermission_ended")
				else:
					var m = end_briefing[0]["badEnding"][current_intermission_message]
					var msg = m.sender + "\n" + m.message + "\n"
					
					var new_msg_container = HSplitContainer.new()
					var new_msg_label = Label.new()
					var new_msg_icon = TextureRect.new()
					
					new_msg_icon.texture = icon_map[m.sender]
					new_msg_label.text = msg
					new_msg_label.autowrap = true
					new_msg_container.margin_right = 330
					var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
					print(new_msg_icon.texture)
					new_msg_container.add_child(new_msg_icon)
					new_msg_container.add_child(new_msg_label)
					chat_msg_container.add_child(new_msg_container)
					audio.play()
	
					timer = 0
					current_intermission_message += 1
			else:
				var intermission_length = len(end_briefing[0]["goodEnding"])
				if current_intermission_message > len(end_briefing[0]["goodEnding"]) - 1:
					is_intermission = false
					print("intermission end")
					emit_signal("intermission_ended")
				else:
					var m = end_briefing[0]["goodEnding"][current_intermission_message]
					var msg = m.sender + "\n" + m.message + "\n"
					
					var new_msg_container = HSplitContainer.new()
					var new_msg_label = Label.new()
					var new_msg_icon = TextureRect.new()
					
					new_msg_icon.texture = icon_map[m.sender]
					new_msg_label.text = msg
					new_msg_label.autowrap = true
					new_msg_container.margin_right = 330
					var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
					print(new_msg_icon.texture)
					new_msg_container.add_child(new_msg_icon)
					new_msg_container.add_child(new_msg_label)
					chat_msg_container.add_child(new_msg_container)
					audio.play()
	
					timer = 0
					current_intermission_message += 1
	elif is_game_on:
		# Send generic banter randomly when banter is on
		timer += 1 * delta
		if timer > delay:
			var send_message = true if randi() % 2 == 1 else false
			print(send_message)
			if send_message:
				var random_participant = possible_participants[randi() % len(possible_participants) - 1]
				var m = banter[random_participant][randi() % len(banter[random_participant]) - 1]
				var msg = random_participant + "\n" + m + "\n"
				
				var new_msg_container = HSplitContainer.new()
				var new_msg_label = Label.new()
				var new_msg_icon = TextureRect.new()
				
				new_msg_icon.texture = icon_map[random_participant]
				new_msg_label.text = msg
				new_msg_label.autowrap = true
				new_msg_container.margin_right = 330
				var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
				new_msg_container.add_child(new_msg_icon)
				new_msg_container.add_child(new_msg_label)
				chat_msg_container.add_child(new_msg_container)
				audio.play()
			timer = 0
