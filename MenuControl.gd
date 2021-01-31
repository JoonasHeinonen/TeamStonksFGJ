extends Control

# MenuControl: Initialization for the main menu
# Includes NewGame and ExitGame buttons with
# their respective functionalities.

signal start_game
signal quit_game

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
	emit_signal("start_game")

func quitGame():
	emit_signal("quit_game")
