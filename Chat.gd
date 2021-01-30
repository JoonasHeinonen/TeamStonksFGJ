extends Control

# Define base variables
var playerName = null
var playerReplies = [
	"All right! This should be the file!", "Here you go.", "Okay! Hope this is what you're looking for!"
]
var level = 0

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

# Define other needed variables for technical reasons, e.g. random numbers
var rng = RandomNumberGenerator.new()

# Setter functions
func setLevel(lvl):
	level = lvl
	print("Current level is: ", level)

func setPlayerName(name):
	playerName = name
	print("Player name is " + playerName + ".")

# Other functions
func displayBriefing():
	var totalMessages = ""
	
	for m in briefingOne:
		var msg = m.sender + "\n" + m.message + "\n"
		totalMessages = totalMessages + msg + "\n"
		
	return totalMessages

func setPlayerReply():
	var arrayLength = 0
	rng.randomize()
	
	for g in playerReplies:
		arrayLength = arrayLength + 1
	var replyPick = rng.randi_range(arrayLength - 1, 0)
	
	return playerReplies[replyPick]
		
# Inbuilt functions
func _ready():
	setLevel(1)
	setPlayerName("Girdeux")
	
	var LevelLabel = get_node("ChatTextRect/LevelContainer/LevelLabel")
	var PlayerMessage = get_node("ChatTextRect/PlayerMessageContainer/PlayerMessage")
	var CharacterMessage = get_node("ChatTextRect/CharacterMessageContainer/CharacterMessage")
	
	var msg = setPlayerReply()
	
	LevelLabel.text = str("Level ", level)
	PlayerMessage.text = str("")
	CharacterMessage.text = str(displayBriefing())
