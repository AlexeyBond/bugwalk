extends PinJoint2D

@export_range(1.1, 10) var hysteresis: float = 2.0

var _pseudomotor_enabled: bool = false

func _physics_process(delta: float) -> void:
	var na := get_node(node_a) as PhysicsBody2D
	var nb := get_node(node_b) as PhysicsBody2D
	#var d := angle_difference(na.global_rotation, nb.global_rotation)
	var d := nb.global_rotation - na.global_rotation
	
	while d > PI:
		d -= PI

	while d < -PI:
		d += PI

	print(na.global_rotation, ",", nb.global_rotation, ",", d, "..", angular_limit_lower, ",", angular_limit_upper)
	
	var d_over: float = 0.0
	
	if d < angular_limit_lower:
		d_over = d - angular_limit_lower
		_pseudomotor_enabled = true
		motor_enabled = true
	elif d > angular_limit_upper:
		d_over = d - angular_limit_upper
		_pseudomotor_enabled = true
		motor_enabled = true
	else:
		if d * hysteresis > angular_limit_lower and d * hysteresis < angular_limit_upper:
			_pseudomotor_enabled = false
			motor_enabled = true

	if _pseudomotor_enabled:
		var v: float = -sign(d) * (1.0 + 5000 * min(abs(d_over), 1.0)) * 50
		motor_target_velocity = v
		print(v)
		#if na is RigidBody2D:
			#na.apply_torque(-v)
		#if nb is RigidBody2D:
			#nb.apply_torque(v)
