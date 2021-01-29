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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Click drag using mouse cursor
	pass
