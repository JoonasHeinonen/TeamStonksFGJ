extends GridContainer


# GameFileArranger - Game file viewing window.
# Populated upon init with files and directories according to params
onready var file_object_scene = preload("res://Objects/FileObject.tscn")
var dragged_item = null  # TODO: Add signal to chat to determine if file is correct


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize(2)

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
			var new_file = file_object_scene.instance()
			add_child(new_file)
			if sublevel > round(sublevels / 2):
				for sub_file_object in new_file.get_children():
					sub_file_object.is_correct_file = true
					sub_file_object.set_type("folder")

func instance_file_object(type):
	if type == "folder":
		pass
	elif type == "directory":
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
