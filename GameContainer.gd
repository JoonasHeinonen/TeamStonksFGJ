extends Control


# GameContainer: Let this instantiate the game itself
# Should contain Folder view and Game window and also control
# dragged object and current level parameters


onready var file_object_scene = preload("res://Objects/FileObject.tscn")
var dragged_item = null  # TODO: Add signal to chat to determine if file is correct

# Level Stats
var sublevel = 0

onready var file_view = get_node("WindowContainer/GameFileArranger")
onready var chat_view = get_node("ChatContainer")
onready var folder_image = preload("res://gfx/folder.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize(3)
	
func instance_file_object(type):
	var new_file = file_object_scene.instance()
	if type == "folder":
		new_file.set_folder()
	# TODO: Determine file types and stuff randomly

	return new_file
	
func _process(delta):
	if dragged_item:
		get_node("Dragged").position = get_viewport().get_mouse_position()
	else:
		if get_node("Dragged"):
			get_node("Dragged").queue_free()
	
func _input(event):
	if Input.is_action_just_released("Click"):
		dragged_item = null
	
func _file_pressed_signal(file_instance):
	if not file_instance.is_folder:
		# FILE:
		dragged_item = file_instance

		var ghost_image = Sprite.new()
		ghost_image.texture = file_instance.texture_normal
		ghost_image.name = "Dragged"
		ghost_image.modulate = Color(1, 1, 1, 0.5)
		ghost_image.scale = Vector2(0.5, 0.5)
		add_child(ghost_image)

	else:
		sublevel = file_instance.sublevel
		print("new sublevel", sublevel)
	
func _create_file_signals(file_instance):
	file_instance.connect("button_down", self, "_file_pressed_signal", [file_instance])

func initialize(difficulty):
	# DIFFICULTY LOGIC:
	# A: Difficulty / 2 = sub-levels of folders (rounded up, min 1)
	# B: Difficulty * 2 + (rand(0, difficulty)) = Possible amount of files inside each folder
	# 1) Create root (sublevel 0)
	# 2) For each sublevel, starting at sublevel 0:
	#   * Create files equal to formula B. Randomly determine if each file is folder
	#   * Mark sublevel for each file and folder
	# 3) If current sublevel < total sublevel, repeat process
	# 4) Determine correct file by choosing one with some modifiers by difficulty
	#   * Never sublevel 0
	#   * Has to be a file from atleast sublevels / 2 (round up)
	#   
	var test_data = {}
	var sublevels = round(difficulty / 2)
	for sublevel in range(0, sublevels):
		var files = difficulty * 2 + (randi() % difficulty)
		for i in range(0, files):
			randomize()
			var is_folder = "folder" if (randi() % 10) > 5 else "file"
			var new_file = instance_file_object(is_folder)
			# Just Godot things; have to change texture later
			file_view.add_child(new_file)
			if is_folder == "folder":
				new_file.texture_normal = folder_image
			_create_file_signals(new_file)
			if sublevel > round(sublevels / 2):
				for sub_file_object in new_file.get_children():
					sub_file_object.is_correct_file = true
