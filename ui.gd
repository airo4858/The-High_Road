extends CanvasLayer

var health : int = 3
var player : CharacterBody3D

func _ready():
	player = get_node("/root/Main/ProtoController")

func _physics_process(delta: float):
	$Health.text = "Health: " + str(player.health)
