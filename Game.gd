extends Node2D


# Game Object: Track all game status, main for code

# Local Constants
var STATE_MENU = "menu"
var STATE_GAME = "game"
var STATE_INTRO = "intro"
var STATE_GAMEOVER = "game_over"
var STATE_AFTERMATH = "after_screen"
var AVAILABLE_STATES = [
	STATE_MENU, 
	STATE_GAME, 
	STATE_INTRO, 
	STATE_GAMEOVER, 
	STATE_AFTERMATH
]

# Declare member variables here.
export var level = 1
var time_left = 60
var game_state = null
var failed_levels = 0
var score = 0
var level_won = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_game_state(STATE_GAME)
	
func set_game_state(new_state):
	if new_state in AVAILABLE_STATES:
		game_state = new_state
		call(new_state)
		
# State changer commands. Fill in as necessary!
func menu():
	print("menu running")
	
func game():
	# Switch to game screen and do things!
	print("switching to game screen")
	
func intro():
	pass
	
func game_over():
	pass
	
func after_screen():
	pass
