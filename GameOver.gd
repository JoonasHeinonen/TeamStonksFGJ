extends Control

signal go_main_menu


func _on_Button_pressed():
	emit_signal("go_main_menu")
