extends State
class_name Attacking

var target: CharacterBody3D
var chasing_state : State
var detection : Area3D
var attack : Area3D
var leave_attack : Array
var right_punch : bool
var animation : AnimationPlayer

func initialize():
	chasing_state = get_parent().get_node("Chasing")
	detection = body.get_node("Detection")
	attack = body.get_node("Attack")
	animation = get_parent().get_parent().get_node("Model/Humanoid_Rigged Great/AnimationPlayer")
	right_punch = false
	
func process_state(delta: float):
	#print("Attacking")
	body.move_and_slide()
	body.look_at(target.global_transform.origin, Vector3.UP)
	body.rotate_y(deg_to_rad(180))
	
	body.velocity.y -= -body.get_gravity().y * delta 
	body.velocity.x = 0
	body.velocity.z = 0
	
	if right_punch == false:
		animation.play("punch_R")
		await animation.animation_finished
		right_punch = true
	else:
		animation.play("punch_L")
		await animation.animation_finished
		right_punch = false
	
	leave_attack = attack.get_overlapping_bodies()
	
	if (leave_attack.is_empty()):
		change_state.emit(chasing_state, "Chasing")
