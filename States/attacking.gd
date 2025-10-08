extends State
class_name Attacking

#func initialize():
	#yep
	
func process_state(delta: float):
	body.move_and_slide()
