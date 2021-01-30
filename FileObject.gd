extends TextureButton


# FileObject - something you are supposed to drag into the chat meetings!

var FILETYPE_TEXT = "text"
var FILETYPE_IMAGE = "image"
var FILETYPE_AUDIO = "audio"
var FILETYPE_CHART = "chart"
var FILETYPE_SHEET = "sheet"
var FILETYPE_OTHER = "other"
var FILETYPE_EXECUTABLE = "exe"
var ALLOWED_TYPES = [
	FILETYPE_TEXT,
	FILETYPE_IMAGE,
	FILETYPE_AUDIO,
	FILETYPE_CHART,
	FILETYPE_SHEET,
	FILETYPE_OTHER,
	FILETYPE_EXECUTABLE
]

# Declare member variables here.
export var file_name = "file"
export var file_ending = "txt"
export var is_folder = false  # If folder, can have 
export var type = "text"
export var is_correct_file = false
export var hint_text = "hint text"
export var image = ""  # Path reference for file for texture change
var hint_image = ""
var parent_file = null  # What folder this file is under
var dragging = false
var sublevel = 0  # What level file is this; hide all other files
var child_folder = null  # Ensure that folders can only have one child (you can not access multiple parents from single child)
onready var folder_image = preload("res://gfx/folder.png")
onready var file_image = preload("res://gfx/file.png")

func set_folder():
	texture_normal = folder_image
	is_folder = true
	is_correct_file = false  # folder can never be correct file

func set_type(new_type):
	if new_type in ALLOWED_TYPES:
		type = new_type
		# TODO: Other file processing as necessary
