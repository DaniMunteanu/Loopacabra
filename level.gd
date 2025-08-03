extends Node2D

func _ready() -> void:
	Global.day_number += 1
	Global.day_started.emit()
