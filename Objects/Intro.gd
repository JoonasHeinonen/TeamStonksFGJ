extends Control


signal go_game


func _on_Button_pressed():
	emit_signal("go_game")
