extends CanvasLayer

@onready var label: Label = $Label
var indication_label: String = "Press the correct chords!"
var your_turn_label: String = "Your turn!"
var success_label: String = "Success!!"
var fail_label: String = "Failed :("

const CHORDS_NUMBER = 5

var chords := []
var picked_chords_index := []
var number_of_picks = 3

var rng = RandomNumberGenerator.new()

var target_animal: CharacterBody2D
var time_earned: int = 1000
var score_points: int = 50

func init_chords_array():
	chords.resize(CHORDS_NUMBER)
	for i in CHORDS_NUMBER:
		chords[i] = get_node("Chord" + str(i))

func _ready() -> void:
	label.text = indication_label
	init_chords_array()
	disable_chords()
	visible = false
	Global.minigame_started.connect(_on_minigame_started)
	
func disable_chords():
	for i in CHORDS_NUMBER:
		chords[i].disabled = true
		
func enable_chords():
	for i in CHORDS_NUMBER:
		chords[i].disabled = false
	
func _on_minigame_started(animal: CharacterBody2D):
	visible = true
	target_animal = animal
	
	await get_tree().create_timer(1).timeout
	
	await pick_chords_order()
	
	enable_chords()
	label.text = your_turn_label
	
func pick_chords_order():
	picked_chords_index.resize(number_of_picks)
	for i in number_of_picks:
		var picked_index = rng.randi_range(0,CHORDS_NUMBER-1)
		picked_chords_index[i] = picked_index
		await chords[picked_index].pick()
		
func _on_minigame_won():
	label.text = success_label
	
	await get_tree().create_timer(0.5).timeout
	
	Global.minigame_won.emit(time_earned, score_points)
	target_animal.end_interaction()
	disable_chords()
	visible = false
	label.text = indication_label
	
func _on_minigame_lost():
	label.text = fail_label
	
	await get_tree().create_timer(0.5).timeout
	
	target_animal.end_interaction()
	disable_chords()
	visible = false
	label.text = indication_label
