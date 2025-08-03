extends Node2D

@onready var MAIN_MENU = preload("res://UI_Elements/MainMenu.tscn")
@onready var LEVEL = preload("res://Level.tscn")
@onready var GAME_OVER_DAY = preload("res://UI_Elements/GameOverDay.tscn")
@onready var GAME_OVER_NIGHT = preload("res://UI_Elements/GameOverNight.tscn")

var current_main_menu
var current_level
var current_game_over_day
var current_game_over_night

func _ready() -> void:
	open_main_menu()
	Global.switch_to_next_day.connect(start_new_level)
	Global.start_new_game.connect(_on_new_game)
	Global.game_over_day.connect(_on_game_over_day)
	Global.game_over_night.connect(_on_game_over_night)
	Global.return_to_main_menu.connect(_on_return_to_main_menu)

func open_main_menu():
	current_main_menu = MAIN_MENU.instantiate()
	add_child(current_main_menu)

func initialize_new_game_state():
	Global.game_over = false
	Global.day_number = 0
	Global.score = 0

func start_new_level():
	TransitionScreen.transition_black()
	await TransitionScreen.on_transition_finished
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	current_level = LEVEL.instantiate()
	add_child(current_level)
	
	if current_main_menu != null:
		current_main_menu.queue_free()
		current_main_menu = null
	elif current_game_over_day != null:
		current_game_over_day.queue_free()
		current_game_over_day = null
	elif current_game_over_night != null:
		current_game_over_night.queue_free()
		current_game_over_night = null
	
	TransitionScreen.ready_for_fade_out.emit()

func _on_new_game():
	initialize_new_game_state()
	start_new_level()
	
func _on_game_over_day():
	Global.game_over = true
	
	TransitionScreen.transition_black()
	await TransitionScreen.on_transition_finished
	
	current_level.queue_free()
	current_level = null
	
	current_game_over_day = GAME_OVER_DAY.instantiate()
	add_child(current_game_over_day)
	
	TransitionScreen.ready_for_fade_out.emit()
	
func _on_game_over_night():
	Global.game_over = true
	
	TransitionScreen.transition_black()
	await TransitionScreen.on_transition_finished
	
	current_level.queue_free()
	current_level = null
	
	current_game_over_night = GAME_OVER_NIGHT.instantiate()
	add_child(current_game_over_night)
	
	TransitionScreen.ready_for_fade_out.emit()
	
func _on_return_to_main_menu():
	TransitionScreen.transition_black()
	await TransitionScreen.on_transition_finished
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
		
	current_main_menu = MAIN_MENU.instantiate()
	add_child(current_main_menu)
	
	if current_game_over_day != null:
		current_game_over_day.queue_free()
		current_game_over_day = null
	elif current_game_over_night != null:
		current_game_over_night.queue_free()
		current_game_over_night = null
	
	TransitionScreen.ready_for_fade_out.emit()
