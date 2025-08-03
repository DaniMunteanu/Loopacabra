extends CanvasLayer

signal on_transition_finished
signal ready_for_fade_out

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(animation_name):
	if animation_name == "fade_to_normal":
		color_rect.visible = false
	else:
		on_transition_finished.emit()

func _on_ready_for_fade_out() -> void:
	animation_player.play("fade_to_normal")
		
func transition_black():
	color_rect.visible = true
	animation_player.play("fade_to_black")
