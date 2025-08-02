extends CanvasLayer

const CHORDS_NUMBER = 5

var chords := []
var picked_chords_index := []
var number_of_picks = 3

var rng = RandomNumberGenerator.new()

func init_chords_array():
	chords.resize(CHORDS_NUMBER)
	for i in CHORDS_NUMBER:
		chords[i] = get_node("Chord" + str(i))

func _ready() -> void:
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
	
	await get_tree().create_timer(1).timeout
	
	await pick_chords_order()
	
	enable_chords()
	
func pick_chords_order():
	picked_chords_index.resize(number_of_picks)
	for i in number_of_picks:
		var picked_index = rng.randi_range(0,CHORDS_NUMBER-1)
		picked_chords_index[i] = picked_index
		await chords[picked_index].pick()
