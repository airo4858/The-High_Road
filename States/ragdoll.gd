extends State
class_name Ragdoll

var ragdoll_state : State
var collision : CollisionShape3D
var skeleton : Skeleton3D
var animation : AnimationPlayer
var model : Node3D
var helmet : MeshInstance3D
var poof_sound : AudioStreamPlayer
var sound_bool : bool = false

func initialize():
	ragdoll_state = get_parent().get_node("Ragdoll")
	collision = get_parent().get_parent().get_node("Collision")
	skeleton = get_parent().get_parent().get_node("Model/Humanoid_Rigged Great/Rig/Skeleton3D")
	animation = get_parent().get_parent().get_node("Model/Humanoid_Rigged Great/AnimationPlayer")
	model = get_parent().get_parent().get_node("Model")
	helmet = get_parent().get_parent().get_node("Mesh")
	poof_sound = get_parent().get_parent().get_node("PoofSound")

func process_state(delta: float):
	#print("Ragdoll")
	helmet.visible = false
	model.visible = false
	animation.play("poof")
	if sound_bool == false:
		poof_sound.play()
		sound_bool = true
	await animation.animation_finished
	poof_sound.stop()
	sound_bool = false
	#await get_tree().create_timer(5).timeout
	body.queue_free()
