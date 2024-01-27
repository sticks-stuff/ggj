extends CharacterBody3D

@export var speed = 14
@export var max_distance = 50

var target_velocity = Vector3.ZERO
var target_position = null
var start_position = Translation
var direction = Vector3.ZERO

var minAttackSizeX = -8 # lol
var maxAttackSizeX = 8 # lol
var minAttackSizeZ = -4 # lol
var maxAttackSizeZ = 4 # lol

func _ready():
	print(findAttackRandom())

func findAttackRandom() -> Vector3:
	var x = randf_range(minAttackSizeX, maxAttackSizeX)
	var z = randf_range(minAttackSizeZ, maxAttackSizeZ)
	return Vector3(x, 0.6, z)


func lookAndLerp(target_position, speed, delta):
	look_at(target_position, Vector3.UP)
	direction = (target_position - global_transform.origin).normalized()
	target_velocity = direction * speed
	
	# Smooth the velocity
	velocity.x = lerp(velocity.x, target_velocity.x, (delta * 1)) # magic number 10 :)
	velocity.z = lerp(velocity.z, target_velocity.z, (delta * 1))

	velocity = target_velocity
	# Moving the Character
	move_and_slide()

func _physics_process(delta):
	var curSpeed = speed
	if target_position == null:
		target_position = findAttackRandom()
	var current_position = self.global_transform.origin
	if current_position.distance_to(target_position) > 0.5:
		lookAndLerp(target_position, curSpeed, delta)
		print("Moving to: ", target_position, " from: ", current_position)
	else:
		print("Reached: ", target_position)
		target_position = null
		target_velocity = Vector3.ZERO
