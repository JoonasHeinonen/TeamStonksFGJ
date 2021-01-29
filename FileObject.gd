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
var dragging = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var children = get_children()
	
	# TODO: Populate cursor file pointer somewhere
	if dragging:
		var ghost_image = get_node("/root/Dragged")
		if ghost_image:
			ghost_image.position = get_viewport().get_mouse_position()
	else:
		var ghost_image = get_node("/root/Dragged")
		if ghost_image:
			ghost_image.queue_free()

func set_type(new_type):
	if new_type in ALLOWED_TYPES:
		type = new_type
		# TODO: Other file processing as necessary

func _input(event):
	# Check if mouse button is released
	if event is InputEventMouseButton and not event.pressed:
		dragging = false

func _on_FileObject_gui_input(event):
	# Check if mouse is pressed within file boundaries
	print(event)
	if event is InputEventMouseButton and event.pressed:
		dragging = true
		
		var ghost_image = Sprite.new()
		ghost_image.texture = texture_normal
		ghost_image.name = "Dragged"
		ghost_image.modulate = Color(1, 1, 1, 0.5)
		get_node("/root").add_child(ghost_image)
