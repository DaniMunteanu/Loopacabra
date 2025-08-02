extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactable: Area2D = $Interactable

func _ready() -> void:
	interactable.interact = _on_interact
	
	animation_player.play("IdleLeft")
	
func _on_interact():
	Global.minigame_started.emit(self)
