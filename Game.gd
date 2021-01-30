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
var timer = false
var game_state = null
var failed_levels = 0
var level_misses = 0
var score = 0
var level_won = false
var game_instance = null
var game_instance_weakref = null
var level_running = true

# Load scenes
onready var game_scene = preload("res://Objects/GameContainer.tscn")
onready var intro_scene = preload("res://Objects/Intro.tscn")
onready var game_over_scene = preload("res://Objects/GameOver.tscn")
onready var aftermath_scene = preload("res://Objects/Aftermath.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  # Initialize randomness
	set_game_state(STATE_GAME)
	
func set_game_state(new_state):
	if new_state in AVAILABLE_STATES:
		game_state = new_state

		# Set weakref of game instance to fix issues with process()-func
		game_instance_weakref = null
		# Empty all children for each state change
		for child in get_children():
			child.queue_free()
		call(new_state)

# Signal functions game
func _correct_file():
	# Increase score by 1
	_level_end(false)
	
func _wrong_file():
	# Mark one level-specific failure or end level
	level_misses += 1
	if game_instance:
		game_instance.update_level_misses(level_misses)
	if level_misses >= 3:
		_level_end(true)
		
func _time_over():
	# Time out level ending
	_level_end(true)
	
func _level_start():
	# Start timer
	timer = true
	time_left = 15
	level_misses = 0
	if game_instance_weakref:
		game_instance.initialize(level)
		game_instance.update_level_misses(level_misses)
		game_instance.update_timer(time_left)
	
func _level_end(game_over):
	# Start next level or go to gameover
	if game_over == true:
		# TODO: Transition to gameover screen
		failed_levels += 1
		if failed_levels >= 3:
			timer = false
			set_game_state(STATE_GAMEOVER)
	level += 1
	if level > 5:
		# You won!
		timer = false
		set_game_state(STATE_AFTERMATH)
	else:
		_level_start()
	
func _process(delta):
	if timer:
		time_left -= 1 * delta
		if game_instance_weakref != null:
			game_instance.update_timer(time_left)
		if time_left <= 0:
			_time_over()

# State changer commands. Fill in as necessary!
func menu():
	print("menu running")
	
func game():
	# Switch to game screen and do things!
	var game_scene_instance = game_scene.instance()
	add_child(game_scene_instance)
	game_scene_instance.connect("correct_file", self, "_correct_file")
	game_scene_instance.connect("wrong_file", self, "_wrong_file")
	game_scene_instance.connect("level_start", self, "_level_start")
	game_scene_instance.connect("level_end", self, "_level_end")
	game_instance = game_scene_instance
	
	# We need the weakref to work with _process to check that the timer still exists
	game_instance_weakref = weakref(game_scene_instance)
	_level_start()
	
func intro():
	# Transition to an Intro cutscene
	var intro_scene_instance = intro_scene.instance()
	add_child(intro_scene_instance)
	
func game_over():
	# Transition to a Game Over Screen
	timer = false
	var game_over_scene_instance = game_over_scene.instance()
	add_child(game_over_scene_instance)
	
func after_screen():
	# Transition to a Game Over Screen
	var aftermath_scene_instance = aftermath_scene.instance()
	add_child(aftermath_scene_instance)
