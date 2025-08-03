extends Node

var player_current_position: Vector2
var day_number: int = 0
var score: int = 0
var game_over: bool = false

signal minigame_started(animal: CharacterBody2D)
signal minigame_ended()

signal minigame_won(time_earned: int, score_points: int)

signal switch_to_night()
signal switch_to_next_day()

signal alert_enemy_dogs()

signal day_started()
signal score_points_earned(points: int)

signal start_new_game()
signal return_to_main_menu()

signal game_over_day()
signal game_over_night()
