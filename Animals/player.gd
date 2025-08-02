extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var interacting_component: Node2D = $InteractingComponent

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum player_states {IDLE, WALKING, MINIGAME, DEAD}
var current_state = player_states.IDLE

enum player_direction {LEFT, RIGHT}
var current_direction = player_direction.LEFT

func _ready() -> void:
	Global.minigame_started.connect(_on_minigame_started)

func _on_minigame_started(animal: CharacterBody2D):
	var walking_angle = rad_to_deg(self.get_angle_to(animal.global_position))
	if walking_angle < 0:
		walking_angle += 360
	match floor(walking_angle/90.0):
		1.0, 2.0:
			current_direction = player_direction.LEFT
		0.0, 3.0:
			current_direction = player_direction.RIGHT
			
	current_state = player_states.MINIGAME
	
	
	var middle = (global_position + animal.global_position) / 2.0
	camera.global_position.x = middle.x - 50
	camera.global_position.y = middle.y - 50
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(2,2), 1.0)

func update_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	
func update_sprite():
	if velocity.length() > 0.0:
		var walking_angle = rad_to_deg(velocity.angle())
		if walking_angle < 0:
			walking_angle += 360
		match floor(walking_angle/90.0):
			1.0, 2.0:
				animation_player.play("WalkingDayLeft")
				current_direction = player_direction.LEFT
			0.0, 3.0:
				animation_player.play("WalkingDayRight")
				current_direction = player_direction.RIGHT
	else:
		match current_direction:
			player_direction.LEFT:
				animation_player.play("IdleDayLeft")
			player_direction.RIGHT:
				animation_player.play("IdleDayRight")

func _physics_process(delta: float) -> void:
	match current_state:
		player_states.IDLE, player_states.WALKING:
			update_movement()
			update_sprite()
		player_states.MINIGAME:
			update_sprite()
