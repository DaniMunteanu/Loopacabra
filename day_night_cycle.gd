extends CanvasModulate

@export var gradient = GradientTexture1D 
@export var INGAME_SPEED = 50.0

var time: float = 0.0
var is_daytime: bool = true

const MINUTES_PER_DAY = 1440
const INGAME_REAL_MINUTE_RATIO = (2 * PI) / MINUTES_PER_DAY

func _process(delta: float) -> void:
	time += delta * INGAME_REAL_MINUTE_RATIO * INGAME_SPEED
	var value = (sin(time) + 1.0 ) / 2.0
	color = gradient.gradient.sample(value)

	if value < 0.5 && is_daytime:
		is_daytime = false
		Global.switch_to_night.emit()
