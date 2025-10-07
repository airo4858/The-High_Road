extends State
class_name Chasing

@export var chase_speed: float = 70.0
var target: CharacterBody2D
var attacking_state : State
var idle_state : State
var detection : Area3D
var attack : Area3D
var leave_detection : Array
var enter_attack : Array


func initialize():
	detection = body.get_node("Detection")
	attacking_state = get_parent().get_node("Attacking")
	idle_state = get_parent().get_node("Idle")

func _physics_process(delta: float):
	#body.velocity = (target.position - body.position).normalized() * chase_speed
	#body.move_and_slide()
	#body.get_gravity() * delta
	#var direction = (target.global_transform.origin - body.global_transform.origin)
	#direction.y = 0
	#direction = direction.normalized()
#
		## Set horizontal velocity toward target
	#body.velocity.x = direction.x * chase_speed
	#body.velocity.z = direction.z * chase_speed
#
		## Apply gravity to vertical velocity
	#body.velocity.y -= body.get_gravity() * delta
#
		## Move the body
	#body.move_and_slide()
#
		## Rotate to face the target
	#body.look_at(target.global_transform.origin, Vector3.UP)
	
	
	leave_detection = detection.get_overlapping_bodies()
	enter_attack = attack.get_overlapping_bodies()
	
	if (leave_detection.is_empty()):
		change_state.emit(idle_state, "Idle")
	
	if (not enter_attack.is_empty()):
		change_state.emit(attacking_state, "Attacking")
