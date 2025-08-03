extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactable: Area2D = $Interactable
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health: Health = $Health

var is_alerted: bool = false
var damage: int = 1
var speed: int = 250
var direction: Vector2
var kill_points: int = 100

enum enemy_direction {LEFT, RIGHT}
var current_direction = enemy_direction.LEFT

enum dog_states {IDLE, WALKING, ATTACKING}
var current_state = dog_states.IDLE

func _ready() -> void:
	init_health_bar()
	interactable.interact = _on_interact
	health_bar.visible = false
	Global.switch_to_night.connect(_on_switch_to_night)
	Global.alert_enemy_dogs.connect(_on_alert)
	health.health_changed.connect(_update_health_bar)

	animation_player.play("IdleLeft")
	
func _physics_process(delta: float) -> void:
	match current_state:
		dog_states.IDLE:
			match current_direction:
				enemy_direction.LEFT:
					animation_player.play("IdleLeft")
				enemy_direction.RIGHT:
					animation_player.play("IdleRight")
		dog_states.WALKING:
			if is_alerted:
				direction = global_position.direction_to(Global.player_current_position).normalized()
				if global_position.distance_to(Global.player_current_position) < 70.0:
					velocity = Vector2.ZERO
					match current_direction:
						enemy_direction.LEFT:
							animation_player.play("AttackLeft")
						enemy_direction.RIGHT:
							animation_player.play("AttackRight")
					current_state = dog_states.ATTACKING
				else:
					velocity = direction * speed
					move_and_slide()
			
					var walking_angle = rad_to_deg(global_position.angle_to_point(Global.player_current_position))
					if walking_angle < 0.0:
						walking_angle += 360.0
						
					match floor(walking_angle/90.0):
						1.0, 2.0:
							current_direction = enemy_direction.LEFT
						0.0, 3.0:
							current_direction = enemy_direction.RIGHT
						
					match current_direction:
						enemy_direction.LEFT:
							animation_player.play("WalkingLeft")
						enemy_direction.RIGHT:
							animation_player.play("WalkingRight")
			else:
				pass
				
func _on_interact():
	Global.minigame_started.emit(self)

func end_interaction():
	interactable.is_interactable = false
	Global.minigame_ended.emit()
	
func _on_attack_ended():
	current_state = dog_states.WALKING
	
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

func _on_hitbox_area_entered(hurtbox: Hurtbox) -> void:
	hurtbox.take_damage(damage)
	
func _on_alert():
	is_alerted = true
	current_state = dog_states.WALKING

func _on_health_health_depleted() -> void:
	Global.score += kill_points
	Global.score_points_earned.emit()
	queue_free()
