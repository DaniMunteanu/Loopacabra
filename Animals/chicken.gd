extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactable: Area2D = $Interactable
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	interactable.interact = _on_interact
	health_bar.visible = false
	Global.switch_to_night.connect(_on_switch_to_night)

	animation_player.play("IdleLeft")
	
func _on_interact():
	Global.minigame_started.emit(self)

func end_interaction():
	interactable.is_interactable = false
	Global.minigame_ended.emit()
	
func _on_switch_to_night():
	health_bar.visible = true
