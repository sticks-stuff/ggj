extends CharacterBody3D
@export var speed = 15
@export var max_speed = 30  # Maximum speed

func _physics_process(delta):
	var forward_direction = transform.basis.z
	var target_velocity = forward_direction * max_speed  # Target velocity is forward direction times max speed

	# Lerp the current velocity to the target velocity
	velocity = lerp(velocity, target_velocity, delta * speed)

	# Apply the velocity
	move_and_slide()
