extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var interacting_component: Node2D = $InteractingComponent
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health: Health = $Health

const SPEED = 300.0
const DAMAGE = 1

enum player_states {IDLE, WALKING, MINIGAME, TRANSFORMING, ATTACKING, DEAD}
var current_state = player_states.IDLE

enum player_direction {LEFT, RIGHT}
var current_direction = player_direction.LEFT
var is_transformed: bool = false
var first_blood: bool = false

func _ready() -> void:
	init_health_bar()
	Global.minigame_started.connect(_on_minigame_started)
	Global.minigame_ended.connect(_on_minigame_ended)
	Global.switch_to_night.connect(_on_switch_to_night)
	health.health_changed.connect(_update_health_bar)

func init_health_bar():
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
	health_bar.get_node("HealthBarBack").max_value = health.max_health
	health_bar.get_node("HealthBarBack").value = health.current_health
	
func _update_health_bar(diff: int):
	health_bar.value = health.current_health
	
	await get_tree().create_timer(0.5).timeout
	health_bar.get_node("HealthBarBack").value = health.current_health

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

func _on_minigame_ended():
	camera.global_position = global_position
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(1,1), 1.0)
	
	if current_state != player_states.TRANSFORMING:
		current_state = player_states.IDLE

func update_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	Global.player_current_position = global_position
	
func update_sprite():
	if velocity.length() > 0.0:
		var walking_angle = rad_to_deg(velocity.angle())
		if walking_angle < 0:
			walking_angle += 360
		match floor(walking_angle/90.0):
			1.0, 2.0:
				current_direction = player_direction.LEFT
				if is_transformed:
					animation_player.play("WalkingNightLeft")
				else:
					animation_player.play("WalkingDayLeft")
				
			0.0, 3.0:
				current_direction = player_direction.RIGHT
				if is_transformed:
					animation_player.play("WalkingNightRight")
				else:
					animation_player.play("WalkingDayRight")
	else:
		match current_direction:
			player_direction.LEFT:
				if is_transformed:
					animation_player.play("IdleNightLeft")
				else:
					animation_player.play("IdleDayLeft")
			player_direction.RIGHT:
				if is_transformed:
					animation_player.play("IdleNightRight")
				else:
					animation_player.play("IdleDayRight")

func _on_switch_to_night():
	if current_state == player_states.MINIGAME:
		Minigame._on_minigame_lost()
		
	current_state = player_states.TRANSFORMING
	match current_direction:
		player_direction.LEFT:
			animation_player.play("TransformLeft")
		player_direction.RIGHT:
			animation_player.play("TransformRight")

func _on_transformation_ended():
	health_bar.visible = true
	current_state = player_states.IDLE
	is_transformed = true
	
func _on_attack_ended():
	current_state = player_states.IDLE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_transformed:
		current_state = player_states.ATTACKING
		match current_direction:
			player_direction.LEFT:
				animation_player.play("AttackLeft")
			player_direction.RIGHT:
				animation_player.play("AttackRight")

func _physics_process(delta: float) -> void:
	match current_state:
		player_states.IDLE, player_states.WALKING:
			update_movement()
			update_sprite()
		player_states.MINIGAME:
			match current_direction:
				player_direction.LEFT:
					animation_player.play("PlayGuitarLeft")
				player_direction.RIGHT:
					animation_player.play("PlayGuitarRight")

func _on_hitbox_area_entered(hurtbox: Hurtbox) -> void:
	hurtbox.take_damage(DAMAGE)
	if first_blood == false:
		first_blood = true
		Global.alert_enemy_dogs.emit()
