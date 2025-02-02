extends Control


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
var intermission = false

# Load scenes
onready var intro_scene = preload("res://Objects/Intro.tscn")
onready var menu_scene = preload("res://Objects/Menu/MenuControl.tscn")
onready var game_over_scene = preload("res://Objects/GameOver.tscn")
onready var aftermath_scene = preload("res://Objects/Aftermath.tscn")
onready var game_scene = preload("res://Objects/GameContainer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  # Initialize randomness
	set_game_state(STATE_MENU)
	
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
	if game_instance_weakref:
		game_instance.initialize(level, 1)
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
	if game_over and level == 5:
		# Instant failure! You lost to the last boss!
		timer = false
		set_game_state(STATE_GAMEOVER)
	if level > 5:
		# You won!
		timer = false
		set_game_state(STATE_AFTERMATH)
	else:
		# start intermission for next level
		if game_instance_weakref:
			var last_level = false
			if level == 5:
				last_level = true
			game_instance.update_blunders(failed_levels, last_level)
		_start_intermission(game_over)
		
func _intermission_ended():
	# Intermission has ended, start next level
	_level_start()
	game_instance.hide_controls()
	game_instance.set_chat_to_new_level(level)
	timer = false
	print("intermission ended")
	print(game_instance)
	
func _start_intermission(game_over):
	game_instance.start_intermission(game_over)
	
func _process(delta):
	if timer and time_left > 0:
		time_left -= 1 * delta
		if game_instance_weakref != null:
			game_instance.update_timer(time_left)
		if time_left <= 0:
			_time_over()

func _start_timer():
	# Start timer for current level
	timer = true
	time_left = 30
	level_misses = 0
	if game_instance_weakref:
		game_instance.show_controls()
	_level_start()

func _quit():
	get_tree().quit()

# State changer commands. Fill in as necessary!
func menu():
	var menu_scene_instance = menu_scene.instance()
	add_child(menu_scene_instance)
	menu_scene_instance.connect("start_game", self, "set_game_state", [STATE_INTRO])
	menu_scene_instance.connect("quit_game", self, "_quit")
	
func game():
	# Switch to game screen and do things!
	var game_scene_instance = game_scene.instance()
	add_child(game_scene_instance)
	game_scene_instance.connect("correct_file", self, "_correct_file")
	game_scene_instance.connect("wrong_file", self, "_wrong_file")
	game_scene_instance.connect("level_end", self, "_level_end")
	game_scene_instance.connect("chat_intro_ended", self, "_start_timer")
	game_scene_instance.connect("chat_intermission_ended", self, "_intermission_ended")
	game_instance = game_scene_instance
	
	# We need the weakref to work with _process to check that the timer still exists
	game_instance_weakref = weakref(game_scene_instance)
	game_scene_instance.set_chat_to_new_level(1)

func intro():
	# Transition to an Intro cutscene
	var intro_scene_instance = intro_scene.instance()
	add_child(intro_scene_instance)
	intro_scene_instance.connect("go_game", self, "set_game_state", [STATE_GAME])
	
func game_over():
	# Transition to a Game Over Screen
	timer = false
	var game_over_scene_instance = game_over_scene.instance()
	add_child(game_over_scene_instance)
	game_over_scene_instance.connect("go_main_menu", self, "set_game_state", [STATE_MENU])
	
func after_screen():
	# Transition to a Game Over Screen
	var aftermath_scene_instance = aftermath_scene.instance()
	add_child(aftermath_scene_instance)
	aftermath_scene_instance.connect("go_main_menu", self, "set_game_state", [STATE_MENU])
