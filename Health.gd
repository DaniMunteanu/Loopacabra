class_name Health

extends Node

signal health_changed(diff: int)
signal health_depleted

@export var max_health: int
@export var current_health: int

func set_current_health(value: int):
	var clamped_value = clampi(value,0,max_health)
	
	if clamped_value != current_health:
		var diff = clamped_value - current_health
		current_health = clamped_value
		health_changed.emit(diff)
		
		if current_health == 0:
			health_depleted.emit()

func _on_hurtbox_received_damage(damage: int) -> void:
	set_current_health(current_health - damage)
