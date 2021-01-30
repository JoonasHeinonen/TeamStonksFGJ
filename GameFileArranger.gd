extends GridContainer


# GameFileArranger - Game file viewing window.
# Populated upon init with files and directories according to params
onready var file_object_scene = preload("res://Objects/FileObject.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_scale = Vector2(0.5, 0.5)  # Set scale to proper
