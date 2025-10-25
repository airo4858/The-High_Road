# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

#var serial: GdSerial
var input_dir : float = 0.0
var left_arm_rotate : float
var right_arm_rotate : float
var right_arm : Area3D
var left_arm : Area3D
var death_box : Area3D
var death_box_checker : Array
var ui : CanvasLayer
var ui_gameover : Label
var ui_animation : AnimationPlayer
var animation : AnimationPlayer
var main_animation : AnimationPlayer
var skeleton : Skeleton3D

var model : Node3D
var helmet : MeshInstance3D

var right_bone_name := "UpperArm.R"
var right_ROTATION_START = Quaternion(0.004, 0.006, 0.600, 0.799).normalized()
var right_ROTATION_END   = Quaternion(0.361, 0.368, 0.553, 0.653).normalized()
var right_INPUT_MIN = 210.0
var right_INPUT_MAX = 115.0
var left_INPUT_MIN = 40.0
var left_INPUT_MAX = 120.0

var left_bone_name := "UpperArm.L"
var left_ROTATION_START = Quaternion(0.004, -0.006, -0.600, 0.799).normalized()
var left_ROTATION_END   = Quaternion(0.361, -0.368, -0.553, 0.653).normalized()

@export var health : int

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 3.25
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "ui_select"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation := 0.0
var move_speed : float = 0.0
var freeflying : bool = false

@export var turn_speed := 0.5

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready() -> void:
	check_input_mappings()
	look_rotation = rotation.y
	#look_rotation.x = head.rotation.x
	right_arm = get_node("RightArm")
	left_arm = get_node("LeftArm")
	death_box = get_node("/root/Main/DeathBox")
	ui = get_node("/root/Main/UI")
	ui_gameover = get_node("/root/Main/UI/GameOver")
	ui_animation = get_node("/root/Main/UI/UIAnimation")
	main_animation = get_node("/root/Main/StartAnimation")
	animation = get_node("Model/Humanoid_Rigged Great/AnimationPlayer")
	skeleton = get_node("Model/Humanoid_Rigged Great/Rig/Skeleton3D")
	model = get_node("Model")
	helmet = get_node("Mesh")

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	#if mouse_captured and event is InputEventMouseMotion:
		#rotate_look(event.relative)
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Use velocity to actually move
	move_and_slide()
	rotate_look(delta)
	if velocity == Vector3(0,0,0):
		animation.stop()
		move_right_arm()
		move_left_arm()
	enter_death_box()

## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(delta: float):
	#look_rotation.x -= rot_input.y * look_speed
	#look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	#look_rotation.y -= rot_input.x * look_speed
	#transform.basis = Basis()
	#rotate_y(look_rotation.y)
	#head.transform.basis = Basis()
	#head.rotate_x(look_rotation.x)

	#if Input.is_action_pressed("look_right"):  # e.g. "a"
		#input_dir = -0.8
	#elif Input.is_action_pressed("look_left"):  # e.g. "d"
		#input_dir = 0.8
	#arduino_input = arduino.camera_control();
	#if (arduino_input >= 600):
		#input_dir = 0.8
	#if (arduino_input <= 424):
		#input_dir = -0.8
	#else:
		#input_dir = 0.0
		
	if input_dir != 0.0:
		# Apply rotation only when a key is pressed
		look_rotation += input_dir * turn_speed * delta
		look_rotation = wrapf(look_rotation, -PI, PI)
		transform.basis = Basis(Vector3.UP, look_rotation)

func set_input_direction(dir: float):
	input_dir = dir
	
func move_left_arm():
	left_arm.rotation_degrees.x = -0.775*left_arm_rotate +21
	
	var left_bone_index = skeleton.find_bone(left_bone_name)
	var left_t = clamp((left_arm_rotate - left_INPUT_MIN) / (left_INPUT_MAX - left_INPUT_MIN), 0.0, 1.0)
	var left_quat = left_ROTATION_START.slerp(left_ROTATION_END, left_t)
	
	var left_pose_transform = skeleton.get_bone_pose(left_bone_index)
	left_pose_transform.basis = Basis(left_quat)
	skeleton.set_bone_pose(left_bone_index, left_pose_transform)
	
func set_left_arm_rotation(rotate: float):
	left_arm_rotate = rotate

func move_right_arm():
	right_arm.rotation_degrees.x = 0.653*right_arm_rotate - 147.05
	
	var right_bone_index = skeleton.find_bone(right_bone_name)
	var right_t = clamp((right_arm_rotate - right_INPUT_MIN) / (right_INPUT_MAX - right_INPUT_MIN), 0.0, 1.0)
	var right_quat = right_ROTATION_START.slerp(right_ROTATION_END, right_t)
		
	var right_pose_transform = skeleton.get_bone_pose(right_bone_index)
	right_pose_transform.basis = Basis(right_quat)
	skeleton.set_bone_pose(right_bone_index, right_pose_transform)
	
func set_right_arm_rotation(rotate: float):
	right_arm_rotate = rotate

func move_player(button: int):
	if button == 1:
		animation.play("walk")
		if !main_animation.is_playing():
			Input.action_press("ui_up")
			right_arm.monitoring = false
			left_arm.monitoring = false
	else:
		velocity = Vector3(0,0,0)
		right_arm.monitoring = true
		left_arm.monitoring = true
		if animation.is_playing():
			animation.stop()
		Input.action_release("ui_up")
		

func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false


func _on_left_arm_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		print("Left Arm Hit")
		body.hit()

func _on_right_arm_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		print("Right Arm Hit")
		body.hit()

func player_hit():
	health -= 1
	if health == 0:
		ui_gameover.visible = true
		helmet.visible = false
		model.visible = false
		animation.play("poof")
		await animation.animation_finished
		queue_free()
		get_tree().paused = true

#func player_ragdoll():
	

func enter_death_box():
	death_box_checker = death_box.get_overlapping_bodies()
	if (not death_box_checker.is_empty() and death_box_checker[0].is_in_group("Player")):
		#Input.action_press("ui_up")
		print("Deathbox")
		#player goes into ragdoll permenantly
		ui_gameover.visible = true
		helmet.visible = false
		model.visible = false
		animation.play("poof")
		await animation.animation_finished
		queue_free()
