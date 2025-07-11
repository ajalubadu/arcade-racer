extends RigidBody2D

# Variablen
@export var acceleration := 3000.0
@export var max_speed := 1000.0
@export var steering_speed := 3.0
@export var grip := 10.0
@export var downforce := 20.0

@export var speed_label_path : NodePath  # Zeigt auf das Label
@onready var speed_label := get_node(speed_label_path)


var input_accel := 0.0
var input_steer := 0.0


func _physics_process(delta):
	input_accel = Input.get_action_strength("up") - Input.get_action_strength("down")
	input_steer = Input.get_action_strength("right") - Input.get_action_strength("left")

	var forward_dir = -transform.y    
	var right_dir = transform.x       

	var velocity_forward = linear_velocity.dot(forward_dir)

	# Beschleunigung
	if velocity_forward < max_speed:
		var force = forward_dir * input_accel * acceleration * delta
		apply_central_force(force)

	# Lenken (abhängig von Geschwindigkeit)
	var speed_factor = clamp(1.0 - abs(velocity_forward) / max_speed, 0.2, 1.0)
	var steer_strength = input_steer * steering_speed * speed_factor * 1000.0  
	apply_torque(steer_strength * sign(velocity_forward))

	# Drift unterdrücken
	var sideways_velocity = right_dir * linear_velocity.dot(right_dir)
	linear_velocity -= sideways_velocity * grip * delta

	# Downforce
	var downforce_force = forward_dir * -1 * linear_velocity.length() * downforce * delta
	apply_central_force(downforce_force)
	
