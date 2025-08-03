extends Control

func _on_new_game_button_pressed() -> void:
	Global.start_new_game.emit()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
