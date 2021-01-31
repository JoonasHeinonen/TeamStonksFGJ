extends Control

# MenuControl: Initialization for the main menu
# Includes NewGame and ExitGame buttons with
# their respective functionalities.

# Menu UIs
onready var NewGame = get_node("Menu/HBoxContainer/MenuContainer/NewGame")
onready var ExitGame = get_node("Menu/HBoxContainer/MenuContainer/ExitGame")

# Scenes where to be moved at
onready var Intro = "res://Objects/Intro.tscn"
onready var Aftermath = "res://Objects/Aftermath.tscn"
onready var Game = "res://Objects/Game.tscn"

func _ready():
	print("Menu")
	NewGame.connect("pressed", self, "startGame")
	ExitGame.connect("pressed", self, "quitGame")

func startGame():
	print("Started a new game!")
	get_tree().change_scene(Intro)

func quitGame():
	get_tree().quit()
