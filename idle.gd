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
	
	potential_targets = detect_range.get_overlapping_bodies()
	
	if (not potential_targets.is_empty()):
		chasing_state.target = (potential_targets[0] as CharacterBody2D)
		change_state.emit(chasing_state, "Chasing")
		
