extends Control

@onready var reputation_bar_front: TextureProgressBar = $ReputationBarFront
@onready var reputation_bar_back: TextureProgressBar = $ReputationBarFront/ReputationBarBack
@onready var label_night: Label = $LabelNight

var meter_max_value: int = 3000
var just_earned_time: bool = false
var is_empty: bool = false

func _ready() -> void:
	Global.switch_to_night.connect(_on_switch_to_night)
	Global.minigame_won.connect(_on_minigame_won)
	
	label_night.visible = false
	
	reputation_bar_front.max_value = meter_max_value
	reputation_bar_front.value = meter_max_value
	
	reputation_bar_back.max_value = meter_max_value
	reputation_bar_back.value = 0
	
func _process(delta: float) -> void:
	if just_earned_time == false:
		reputation_bar_front.value -= 1
	if reputation_bar_front.value == 0 && is_empty == false:
		is_empty = true
		Global.game_over_day.emit()

func _on_minigame_won(time_earned: int, score_points: int):
	just_earned_time = true
	var new_value = clampi(reputation_bar_front.value + time_earned, 0, meter_max_value)
	reputation_bar_back.value = new_value
	
	await get_tree().create_timer(0.5).timeout
	
	reputation_bar_front.value = new_value
	reputation_bar_back.value = 0
	just_earned_time = false
	
func _on_switch_to_night():
	label_night.visible = true
	reputation_bar_front.value = 0
	reputation_bar_back.value = 0
	is_empty = true
