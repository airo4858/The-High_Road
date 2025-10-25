extends Node3D

@onready var starting_camera = $IntroCamera
@onready var player_camera = $ProtoController/Head/Camera3D
@onready var animation = $StartAnimation
@onready var player = $ProtoController
@onready var ui_animation = $UI/UIAnimation
@onready var start_credits = $UI/StartCredits
@onready var health = $UI/Health

var in_start = true

func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	animation.process_mode = Node.PROCESS_MODE_ALWAYS
	#ui_animation.process_mode = Node.ProcessThreadMessages
	starting_camera.process_mode = Node.PROCESS_MODE_ALWAYS
	player.set_physics_process(false)
	starting_camera.current = true
	player_camera.current = false
	animation.play("IntroScene")
	ui_animation.play("StartScreen")

func _process(delta: float):
	pass

func start_game(button: int):
	if in_start == true and button == 0:
		in_start = false
		get_tree().paused = false
		player.set_physics_process(true)
		animation.stop()
		ui_animation.stop()
		start_credits.visible = false
		starting_camera.current = false
		player_camera.current = true
		health.visible = true
