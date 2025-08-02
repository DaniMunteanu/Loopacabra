class_name Chord

extends TextureButton

var index: int

func pick():
	await get_tree().create_timer(0.5).timeout
	
	texture_disabled.region = Rect2(12,0,4,299) #GREEN
	
	await get_tree().create_timer(0.5).timeout
	
	texture_disabled.region = Rect2(4,0,4,299) #DARK GRAY
	
func try_chord():
	if index != get_parent().picked_chords_index[0]:
		get_parent().disable_chords()
		texture_disabled.region = Rect2(16,0,4,299) #RED
		
		await get_tree().create_timer(0.5).timeout
		
		texture_disabled.region = Rect2(4,0,4,299) #DARK GRAY
		
		get_parent()._on_minigame_lost()
	else:
		get_parent().picked_chords_index.erase(index)
		
		if get_parent().picked_chords_index.is_empty():
			get_parent()._on_minigame_won()
		
