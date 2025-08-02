extends Node

signal minigame_started(animal: CharacterBody2D)
signal minigame_ended()

signal minigame_won(time_earned: int, score_points: int)

signal switch_to_night()
signal switch_to_next_day()
