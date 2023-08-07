extends Node3D

var qlcWebSocket = WebSocketPeer.new()

var frequency_range = {
	"sub_low":[20, 50],
	"lows":[20, 250],
	"mids":[200, 2000],
	"highs":[2000, 20000]
}

var patterns = {
	"small":
	[
		{
			"name":"Basic",
			"sets":[
				{
					"name":"set1",
					"lights":"_all",
					"color":"_random",
					"animation_type":"linear",
					"animation":{
						"frequency":"sub_low",
						"effects":"brightness",
						"min":20.0
					},
				}
			]
		}
	]
}
var current_pattern
var spectrum
var current_frequency_range
const FREQ_MAX = 11050.0

const WIDTH = 1000
const HEIGHT = 500

const MIN_DB = 60

const debug_color = Color.DEEP_SKY_BLUE

var socket = WebSocketPeer.new()
# Called when the node enters the scene tree for the first time.


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	current_pattern = patterns.small[0]
	print(socket.connect_to_url("localhost:8888"))
#	for N in get_node("Top Down").get_children():
#		N.light_energy = 0
#		N.light_color = Color.CORNFLOWER_BLUE
#		N.get_children()[0].light_energy = 0
#		N.get_children()[0].light_color = Color.CORNFLOWER_BLUE
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	socket.poll()
	for set in current_pattern.sets:
		if set.animation_type != "none":
			var cfr = frequency_range[set.animation.frequency]
			var magnitude: float = spectrum.get_magnitude_for_frequency_range(cfr[0], cfr[1]).length()
			var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
			var height = energy * HEIGHT
			if set.lights == "_all":
				for N in get_node("Colored").get_children():
					for n in N.get_children():
						var light_colour = max(remap_range(height, 0, 500, 0, 2),remap_range(set.animation.min, 0, 255, 0, 2))
						print(light_colour)
						n.light_energy = light_colour
						n.light_color = debug_color
						n.get_children()[0].light_energy = light_colour
						n.get_children()[0].light_color = debug_color
			if height > 300:
				
				print("0|"+str(int(remap_range(height, 0, 500, 0, 255))))
				socket.send_text("0|255")
			else:
				socket.send_text("0|0")				
						
#			for N in get_node("Top Down").get_children():
#				print(N)
#				N.light_energy = height / 200
#				N.get_children()[0].light_energy = height / 90
	
func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
