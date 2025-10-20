extends CharacterBody3D
class_name Enemy

var ragdoll_state : State

func _ready() -> void:
	ragdoll_state = get_node("StateMachine/Ragdoll")

func hit():
	ragdoll_state.change_state.emit(ragdoll_state, "Ragdoll")

func _on_right_arm_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Right Arm Player Hit")
		body.player_hit()
		
func _on_left_arm_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Left Arm Player Hit")
		body.player_hit()
