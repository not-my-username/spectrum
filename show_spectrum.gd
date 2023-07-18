extends Node2D


const VU_COUNT_LARGE = 500
const VU_COUNT_SMALL = 3

const FREQ_MAX = 11050.0

const WIDTH = 1000
const HEIGHT = 500

const MIN_DB = 60

var spectrum


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	print(AudioServer.get_input_device_list())
	AudioServer.set_input_device("BlackHole 2ch (58)")
	print(AudioServer.get_input_device())

func _process(_delta):
	queue_redraw()


func _draw():
	#warning-ignore:integer_division
	var w = WIDTH / VU_COUNT_LARGE
	var prev_hz = 0
	for i in range(1, VU_COUNT_LARGE+1):
		var hz = i * FREQ_MAX / VU_COUNT_LARGE;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.WHITE)
		prev_hz = hz
	
#	for i in range(1, VU_COUNT_SMALL+1):
#		var hz = i * FREQ_MAX / VU_COUNT_SMALL;
#		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
#		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
#		var height = energy * HEIGHT
#		draw_rect(Rect2(w * i, HEIGHT - height + HEIGHT, w, height), Color.WHITE)
#		prev_hz = hz
	var magnitude: float = spectrum.get_magnitude_for_frequency_range(20, 50).length()
	var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	var height = energy * HEIGHT	
	draw_rect(Rect2(0, HEIGHT - height + HEIGHT, 50, height), Color.WHITE)

	if height > 300:
		print("KICK")
		get_parent().get_parent().get_node("Lights/Side").visible = true
	else:
		get_parent().get_parent().get_node("Lights/Side").visible = false		

#	get_parent().get_parent().get_node("Cube").scale = Vector3(height/150, height/150, height/150)
	
	magnitude = spectrum.get_magnitude_for_frequency_range(20, 250).length()
	energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	height = energy * HEIGHT	
	draw_rect(Rect2(100, HEIGHT - height + HEIGHT, 50, height), Color.WHITE)
	
	
	magnitude = spectrum.get_magnitude_for_frequency_range(200, 2000).length()
	energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	height = energy * HEIGHT	
	draw_rect(Rect2(150, HEIGHT - height + HEIGHT, 50, height), Color.WHITE)
	
	magnitude = spectrum.get_magnitude_for_frequency_range(2000, 20000).length()
	energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	height = energy * HEIGHT	
	draw_rect(Rect2(200, HEIGHT - height + HEIGHT, 50, height), Color.WHITE)
	
