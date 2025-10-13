extends State
class_name Ragdoll

var attack_state: State

func initialize():
	attack_state = get_parent().get_node("Attacking")

func process_state(delta: float):
	print("Ragdoll")
	
