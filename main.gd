extends Node2D

@onready var MAIN_MENU = preload("res://UI_Elements/MainMenu.tscn")
@onready var LEVEL = preload("res://Level.tscn")

var current_main_menu
var current_level

func _ready() -> void:
	open_main_menu()
	Global.switch_to_next_day.connect(_on_next_day)

func open_main_menu():
	current_main_menu = MAIN_MENU.instantiate()
	add_child(current_main_menu)

func initialize_new_game_state():
	Global.day_number = 0
	Global.score = 0

func start_new_level():
	current_level = LEVEL.instantiate()
	
	TransitionScreen.transition_black()
	await TransitionScreen.on_transition_finished
	
	add_child(current_level)
	
	if current_main_menu != null:
		current_main_menu.queue_free()
		current_main_menu = null
		
	TransitionScreen.ready_for_fade_out.emit()

func _on_next_day():
	start_new_level()
