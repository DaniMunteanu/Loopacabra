extends Control

@onready var day_count: Label = $DayCount
@onready var score_count: Label = $ScoreCount

func _update_score():
	score_count.text = "Score: " + str(Global.score)
	
func _update_day():
	day_count.text = "Day: " + str(Global.day_number)

func _ready() -> void:
	_update_day()
	_update_score()
	Global.day_started.connect(_update_day)
	Global.score_points_earned.connect(_update_score)
