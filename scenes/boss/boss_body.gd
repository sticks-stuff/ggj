extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var max_distance = 50

var target_velocity = Vector3.ZERO
var start_position = Translation
var direction = Vector3.ZERO


func _physics_process(delta):
	
	direction.x = randf_range(-1, 1)
	direction.z = randf_range(-1, 1)
	
	# Boss movement

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$Pivot.basis = Basis.looking_at(direction)
		look_at(global_transform.origin + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
