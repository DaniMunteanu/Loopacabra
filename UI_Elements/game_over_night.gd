extends Control

@onready var days_survived: Label = $DaysSurvived
@onready var score: Label = $Score

func _ready() -> void:
	days_survived.text = "Days survived: " + str(Global.day_number)
	score.text = "Score: " + str(Global.score)

func _on_play_again_button_pressed() -> void:
	Global.start_new_game.emit()

func _on_exit_button_pressed() -> void:
	Global.return_to_main_menu.emit()
