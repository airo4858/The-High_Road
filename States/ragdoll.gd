extends State
class_name Ragdoll

var ragdoll_state : State

func initialize():
	ragdoll_state = get_parent().get_node("Ragdoll")

func process_state(delta: float):
	print("Ragdoll")
	body.visible = false
