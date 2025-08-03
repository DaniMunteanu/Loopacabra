extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactable: Area2D = $Interactable
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health: Health = $Health

func _ready() -> void:
	init_health_bar()
	interactable.interact = _on_interact
	health_bar.visible = false
	Global.switch_to_night.connect(_on_switch_to_night)
	health.health_changed.connect(_update_health_bar)

	animation_player.play("IdleLeft")
	
func _on_interact():
	Global.minigame_started.emit(self)

func end_interaction():
	interactable.is_interactable = false
	Global.minigame_ended.emit()
	
func _on_switch_to_night():
	health_bar.visible = true
	
func init_health_bar():
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
	health_bar.get_node("HealthBarBack").max_value = health.max_health
	health_bar.get_node("HealthBarBack").value = health.current_health
	
func _update_health_bar(diff: int):
	health_bar.value = health.current_health
	
	await get_tree().create_timer(0.5).timeout
	health_bar.get_node("HealthBarBack").value = health.current_health
