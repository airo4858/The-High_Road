extends State
class_name Ragdoll

var ragdoll_state : State
var collision : CollisionShape3D

func initialize():
	ragdoll_state = get_parent().get_node("Ragdoll")
	collision = get_parent().get_parent().get_node("Collision")

func process_state(delta: float):
	#print("Ragdoll")
	#ragdoll code
	#add timer so that ragdoll lasts ~5 seconds
	body.visible = false
	collision.disabled = true
