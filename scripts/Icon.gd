extends Sprite3D

var coins = 5
var player_name = "robot"
var hp = 3.5
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Konnichiwa sekai")

func get_sine():
	return sin(timer * 5) * .01
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(0.07)
	timer += delta
	
	translate(Vector3(0, get_sine(), 0))
