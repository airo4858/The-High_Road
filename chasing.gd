extends State
class_name Chasing

@export var chase_speed: float = 70.0
var target: CharacterBody2D
var attacking_state : State
var idle_state : State
var detection : Area3D


func initialize():
	detection = body.get_node("Detection")
	attacking_state = get_parent().get_node("Attacking")
	idle_state = get_parent().get_node("Idle")

func _physics_process(delta: float):
	#body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
	body.get_gravity() * delta
