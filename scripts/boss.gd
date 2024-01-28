extends CharacterBody3D

@export var speed = 14
@export var min_distance = 10

var target_velocity = Vector3.ZERO
var target_position = null
var start_position = Translation
var direction = Vector3.ZERO

var minAttackSizeX = -16 # lol
var maxAttackSizeX = 16 # lol
var minAttackSizeZ = -8 # lol
var maxAttackSizeZ = 8 # lol

func _ready():
	print(findAttackRandom())

func findAttackRandom() -> Vector3:
	var x = randf_range(minAttackSizeX, maxAttackSizeX)
	var z = randf_range(minAttackSizeZ, maxAttackSizeZ)
	return Vector3(x, 0, z)


func lookAndLerp(target_position, speed, delta):
	var direction = (target_position - global_transform.origin).normalized()
	var target_velocity = direction * speed

	# Smooth the velocity
	velocity.x = lerp(velocity.x, target_velocity.x, delta)
	velocity.z = lerp(velocity.z, target_velocity.z, delta)

	# Calculate the target rotation angle
	var target_angle = atan2(direction.x, direction.z)

	# Smoothly rotate the object to face the target position
	var current_angle = self.rotation.y
	var new_angle = lerp(current_angle, target_angle, delta * speed)
	self.rotation.y = new_angle

	# Moving the Character
	move_and_slide()

func slowdown(delta):
	# Reduce the velocity to zero
	velocity.x = lerp(velocity.x, 0.0, delta * 5) # magic number :)
	velocity.z = lerp(velocity.z, 0.0, delta * 5)
	move_and_slide()

var timeAtLastNewTarget = 0
var timeAtReach = null
var hasFired = false

var attack_1 = preload("res://scenes/boss/attack_1.tscn")

func _physics_process(delta):
	var curSpeed = speed
	if target_position == null:
		target_position = findAttackRandom()
		timeAtLastNewTarget = Time.get_ticks_msec()
		if target_position.distance_to(self.global_transform.origin) < min_distance:
			target_position = null
			return
	var current_position = self.global_transform.origin
	if current_position.distance_to(target_position) > 2:
		# print("Moving to: ", target_position, " from: ", current_position)
		lookAndLerp(target_position, curSpeed, delta)
	else:
		slowdown(delta)
		print("Reached: ", target_position)
		if timeAtReach == null:
			timeAtReach = Time.get_ticks_msec()
		if hasFired == false and Time.get_ticks_msec() - timeAtReach > 1000:
			print("Firing")
			var attack_instance = attack_1.instantiate()
			attack_instance.position = self.global_transform.origin
			attack_instance.rotation = self.rotation
			get_parent().add_child(attack_instance)
			hasFired = true
		target_velocity = Vector3.ZERO
		# print("Time since last new target: ", Time.get_ticks_msec() - timeAtLastNewTarget)
		if Time.get_ticks_msec() - timeAtLastNewTarget > 5000: # takes about 4000ms to break after reaching target
			target_position = null
			hasFired = false
			timeAtReach = null
