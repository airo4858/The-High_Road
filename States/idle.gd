extends State
class_name Idle

var detect_range : Area3D
var chasing_state : State
var potential_targets : Array

func initialize():
	detect_range = body.get_node("Detection")
	chasing_state = get_parent().get_node("Chasing")
	
func process_state(delta: float):
	#print("Idle")
	
	body.velocity.y -= -body.get_gravity().y * delta 
	body.move_and_slide()
	
	potential_targets = detect_range.get_overlapping_bodies()
	#print(potential_targets)
	
	if (not potential_targets.is_empty() and potential_targets[0].is_in_group("Player")):
		chasing_state.target = get_parent().get_parent().get_parent().get_parent().get_node("ProtoController")
		#chasing_state.target = (potential_targets[0] as CharacterBody3D)
		change_state.emit(chasing_state, "Chasing")
		
