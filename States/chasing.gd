extends State
class_name Chasing

@export var chase_speed: float = 2.2
var target: CharacterBody3D
var attacking_state : State
var idle_state : State
var detection : Area3D
var attack : Area3D
var leave_detection : Array
var enter_attack : Array
var animation : AnimationPlayer
var hiker_left : Area3D
var hiker_right : Area3D

func initialize():
	detection = body.get_node("Detection")
	attack = body.get_node("Attack")
	attacking_state = get_parent().get_node("Attacking")
	idle_state = get_parent().get_node("Idle")
	animation = get_parent().get_parent().get_node("Model/Humanoid_Rigged Great/AnimationPlayer")
	hiker_left = get_parent().get_parent().get_node("LeftArm")
	hiker_right = get_parent().get_parent().get_node("RightArm")
	#target = get_parent().get_parent().get_parent().get_node("ProtoController")

func process_state(delta: float):
	#body.velocity = (target.position - body.position).normalized() * chase_speed
	#body.get_gravity() * delta
	var direction = (target.transform.origin - body.transform.origin).normalized()
	#direction = direction.normalized()
	animation.play("walk")
	
	var velocity = body.velocity
	velocity.x = direction.x * chase_speed
	velocity.z = direction.z * chase_speed
	velocity.y -= -body.get_gravity().y * delta 
	body.velocity = velocity
	body.move_and_slide()
	
	hiker_left.monitoring = false
	hiker_right.monitoring = false
	body.look_at(target.global_transform.origin, Vector3.UP)
	body.rotate_y(deg_to_rad(180))
	
	#print("Chasing")
	leave_detection = detection.get_overlapping_bodies()
	enter_attack = attack.get_overlapping_bodies()
	
	if (leave_detection.is_empty()):
		change_state.emit(idle_state, "Idle")
	
	if (not enter_attack.is_empty()):
		hiker_left.monitoring = true
		hiker_right.monitoring = true
		change_state.emit(attacking_state, "Attacking")
		attacking_state.target = get_parent().get_parent().get_parent().get_parent().get_node("ProtoController")
