extends Control

signal intro_ended

# Define base variables
var playerName = null
var playerReplies = [
	"All right! This should be the file!", "Here you go.", "Okay! Hope this is what you're looking for!"
]
var level = 0
onready var chat_font = preload("res://gfx/fonts/PaytoneOne.ttf")
onready var LevelLabel = get_node("ChatTextRect/LevelContainer/LevelLabel")
onready var PlayerMessage = get_node("ChatTextRect/PlayerMessageContainer/PlayerMessage")

# Define mission briefings

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

func _determine_portrait(person):
	# Hardcoded portrait determination
	pass

# Define other needed variables for technical reasons, e.g. random numbers
var rng = RandomNumberGenerator.new()
var delay = 2
var timer = 0
var current_intro_message = 0
var is_intro = false
var current_briefing = briefingOne

# Setter functions
func setLevel(lvl):
	level = lvl
	print("Current level is: ", level)

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

func set_intro(level):
	timer = 0
	var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
	is_intro = true
	for child in chat_msg_container.get_children():
		child.queue_free()
	current_intro_message = 0
	current_briefing = _determine_level(level)

func _process(delta):
	
	if is_intro:
		var intro_length = len(briefingOne)
		timer += 1 * delta
		if timer > delay:
			if current_intro_message > len(briefingOne) - 1:
				is_intro = false
				emit_signal("intro_ended")
			else:
				var m = current_briefing[current_intro_message]
				var msg = m.sender + "\n" + m.message + "\n"
				
				var new_msg_label = Label.new()
				new_msg_label.text = msg
				var chat_msg_container = get_node("ChatTextRect/CharacterMessageContainer/VBoxContainer")
				chat_msg_container.add_child(new_msg_label)

				timer = 0
				current_intro_message += 1
