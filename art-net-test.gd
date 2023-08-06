extends Node2D

var qlcWebSocket = WebSocketPeer.new()
var status = false

func _ready():
	qlcWebSocket.connect_to_url("ws://127.0.0.1:8888")


#THIS INPUT EVENT IS JUST AN EXAMPLE TO SHOW HOW THIS COULD BE USED.
#YOU COULD ALSO WIRE PUT PACKET COMMANDS TO GODOT BUTTONS, SLIDERS
#OR ANY OTHER INTERFACE.
#IN THIS EXAMPLE, PRESSING THE 3 KEY SETS CHANNEL 3 TO A VALUE OF 255.
func _input(event):
	if Input.is_key_pressed(KEY_3):
		if status:
			qlcWebSocket.send_text("CH|3|0");
			status = false
		else:
			qlcWebSocket.send_text("CH|3|255");
			status = true

func _process(delta):
	qlcWebSocket.poll()
	if status:
		qlcWebSocket.send_text("CH|3|0");
		status = false
	else:
		qlcWebSocket.send_text("CH|3|255");
		status = true
	pass

func _on_connection(serverPacket):
	qlcWebSocket.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)

