extends Control


# GameContainer: Let this instantiate the game itself
# Should contain Folder view and Game window and also control
# dragged object and current level parameters


onready var file_object_scene = preload("res://Objects/FileObject.tscn")
var dragged_item = null  # TODO: Add signal to chat to determine if file is correct

# Level Stats
var sublevel = 0
var current_folder = null
var prev_folders = []
var next_folders = []
var prev_sublevels = []
var next_sublevels = []

# signals
signal correct_file
signal wrong_file
signal level_end
signal level_start
signal chat_intro_ended
signal chat_intermission_ended

onready var file_view = get_node("WindowContainer/GameFileArranger")
onready var chat_view = get_node("ChatContainer")
onready var folder_image = preload("res://gfx/folder.png")
onready var file_image = preload("res://gfx/file.png")
onready var chat_view_window = get_node("ChatContainer/Chat")

# controls
onready var prev_action = get_node("WindowContainer/HBoxContainer/Prev")
onready var next_action = get_node("WindowContainer/HBoxContainer/Next")
onready var up_action = get_node("WindowContainer/HBoxContainer/Up")
onready var uri = get_node("WindowContainer/HBoxContainer/URI")
onready var timer = get_node("WindowContainer/HBoxContainer2/Timer")
onready var score = get_node("WindowContainer/HBoxContainer2/Score")

var filenames = []
var endings = []

# Called when the node enters the scene tree for the first time.
func _ready():
	chat_view.connect("gui_input", self, "_check_dragged_item")
	prev_action.connect("pressed", self, "_go_prev")
	up_action.connect("pressed", self, "_go_up")
	next_action.connect("pressed", self, "_go_next")
	chat_view_window.connect("intro_ended", self, "_chat_intro_ended")
	chat_view_window.connect("intermission_ended", self, "_chat_intermission_ended")
	
	var filenames_file = File.new()
	filenames_file.open("data/filenames.txt", File.READ)
	var endings_file = File.new()
	endings_file.open("data/endings.txt", File.READ)
	
	while not filenames_file.eof_reached():
		var l = filenames_file.get_line()
		filenames.append(l)
	filenames_file.close()
	while not endings_file.eof_reached():
		var l = endings_file.get_line()
		endings.append(l)
	endings_file.close()
	hide_controls()

func hide_controls():
	get_node("WindowContainer").visible = false
	
func show_controls():
	get_node("WindowContainer").visible = true

func _chat_intro_ended():
	emit_signal("chat_intro_ended")
	
func _chat_intermission_ended():
	emit_signal("chat_intermission_ended")

func instance_file_object(type):
	var new_file = file_object_scene.instance()
	if type == "folder":
		new_file.set_folder()
	# TODO: Determine file types and stuff randomly

	return new_file
	
func _go_up():
	var up_sublevel = sublevel - 1
	var up_folder = null
	if current_folder:
		up_folder = current_folder.parent_file
	if up_sublevel < 1:
		up_sublevel = 1
	sublevel = up_sublevel
	current_folder = up_folder
	_new_sublevel(sublevel, current_folder)
	print(sublevel, current_folder)
	
func _go_prev():
	if len(prev_sublevels) > 1 and len(prev_folders) > 1:
		var prev_sublevel = prev_sublevels[len(prev_sublevels) - 1]
		var prev_folder = prev_folders[len(prev_folders) - 1]
		prev_sublevels.remove(len(prev_sublevels) - 1)
		prev_folders.remove(len(prev_folders) - 1)
		sublevel = prev_sublevel
		current_folder = prev_folder
		_new_sublevel(sublevel, current_folder)
		
		# Add next file/folder to item
		next_sublevels.append(prev_sublevel)
		next_folders.append(prev_folder)
	else:
		_new_sublevel(1, null)
	
func _go_next():
	if len(next_sublevels) > 1 and len(next_folders) > 1:
		var next_sublevel = next_sublevels[len(prev_sublevels) - 1]
		var next_folder = next_folders[len(prev_folders) - 1]
		next_sublevels.remove(len(next_sublevels) - 1)
		next_folders.remove(len(next_folders) - 1)
		sublevel = next_sublevel
		current_folder = next_folder
		_new_sublevel(next_sublevel, next_folder)
	
func _process(delta):
	if dragged_item:
		get_node("Dragged").position = get_viewport().get_mouse_position()
	else:
		if get_node("Dragged"):
			get_node("Dragged").queue_free()
	
func _input(event):
	if Input.is_action_just_released("Click"):
		if dragged_item:
			if chat_view.get_rect().has_point(get_viewport().get_mouse_position()):
				if dragged_item.is_correct_file:
					emit_signal("correct_file")
				else:
					emit_signal("wrong_file")
		dragged_item = null
		
func update_timer(new_time):
	timer.text = str(int(new_time))
	
func update_level_misses(new_score):
	score.text = "Attempts: " + str(new_score)
		
func _new_sublevel(new_sublevel, folder):
	for file in file_view.get_children():
		if folder:
			uri.text = folder.file_name
		if file.sublevel != new_sublevel or file.parent_file != folder:
			file.visible = false
		else:
			file.visible = true
	_debug_sublevel(new_sublevel, folder)
				
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
		# assign previous coordinates
		prev_folders.append(current_folder)
		prev_sublevels.append(sublevel)
		
		# We are going below this sublevel!
		sublevel = file_instance.sublevel + 1
		current_folder = file_instance
		_new_sublevel(sublevel, current_folder)
		
func _create_file_signals(file_instance):
	file_instance.connect("button_down", self, "_file_pressed_signal", [file_instance])

func initialize(difficulty, modifier):
	# DIFFICULTY LOGIC:
	# A: Difficulty / 2 = sub-levels of folders (rounded up, min 1)
	# B: Difficulty * 2 + (rand(0, difficulty)) = Possible amount of files inside each folder
	# 1) Create root (sublevel 0)
	# 2) For each sublevel, starting at sublevel 0:
	#   * Create files equal to formula B.
	#   * Mark sublevel for each file and folder
	# 3) If current sublevel < total sublevel, repeat process
	# 4) Determine correct file by choosing one with some modifiers by difficulty
	#   * Never sublevel 0
	#   * Has to be a file from atleast sublevels / 2 (round up)
	#   
	var sublevels = round(difficulty + modifier / 2)
	randomize()
	
	# First generate all folders for each sublevel
	for sublevel in range(1, sublevels + 1):
		var folders = sublevels
		if folders < 1:
			folders = 1
		for i in range(0, folders):
			var new_file = instance_file_object("folder")
			# Just Godot things; have to change texture here
			file_view.add_child(new_file)
			new_file.texture_normal = folder_image
			_create_file_signals(new_file)
			new_file.sublevel = sublevel
			
			# Generate folder filenames
			var new_filename = "%s" % filenames[randi() % len(filenames)]
			new_file.get_node("Label").text = new_filename

	# For each folder, generate files
	for folder in file_view.get_children():
		if folder.is_folder == true:
			randomize()
	
			# Randomly link the folder to a parent folder if sublevel > 1
			if folder.sublevel > 1:
				var possible_folders = []
				for p_folder in file_view.get_children():
					if p_folder.is_folder == true:
						if p_folder.sublevel == folder.sublevel - 1:
							if p_folder.child_folder == null:
								possible_folders.append(p_folder)
				if len(possible_folders) > 0:
					var chosen_folder = possible_folders[randi() % len(possible_folders)]
					folder.parent_file = chosen_folder
					chosen_folder.child_folder = folder
	
	# 3rd stage: Assign files for each folder according to their set parents and sublevels
	for folder in file_view.get_children():
		if folder.is_folder == true:
			var files = difficulty * modifier + (randi() % difficulty)
			for i in range(1, files + 1):
				var new_file = instance_file_object("file")
				file_view.add_child(new_file)
				new_file.sublevel = folder.sublevel + 1
				new_file.parent_file = folder
				new_file.is_folder = false
				
				# determine file type and name randomly
				var new_filename = "%s.%s" % [
					filenames[randi() % len(filenames)],
					endings[randi() % len(endings)]
				]
				new_file.get_node("Label").text = new_filename
				_create_file_signals(new_file)
				
	# 4th stage: Randomly determine one file from available files to be correct one!
	var possible_files = []	
	for file in file_view.get_children():
		if file.is_folder == false:
			possible_files.append(file)
	
	var correct_file = possible_files[randi() % len(possible_files)]
	correct_file.is_correct_file = true
	correct_file.modulate = Color(1, 0.5, 0.5, 1)

	_new_sublevel(1, null)
	
func set_chat_to_new_level(level):
	chat_view_window.set_intro(level)
	
func start_intermission(game_over):
	# This always starts the intermission determined in set_chat_to_new_level
	chat_view_window.start_intermission(game_over)
	hide_controls()
	
func _debug_sublevel(sublevel, parent_folder):
	var files = []
	var folders = []
	var correct_files = []
	for file in file_view.get_children():
		if file.sublevel == sublevel and file.parent_file == parent_folder:
			if file.is_folder:
				folders.append(file)
			else:
				files.append(file)
			if file.is_folder == false and file.is_correct_file:
				correct_files.append(file)
			
	print("Num of files in this sublevel for this parent folder")
	print(len(files))
	print("Num of folders in this sublevel for this parent folder")
	print(len(folders))
	print("Num of correct files in this sublevel for this parent folder")
	print(len(correct_files))
