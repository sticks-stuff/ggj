extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

var target_velocity = Vector3.ZERO

var direction = Vector3.ZERO

func _physics_process(delta):
	var curSpeed = speed
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.z += 1
	if Input.is_action_pressed("up"):
		direction.z -= 1
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left") and not Input.is_action_pressed("down") and not Input.is_action_pressed("up"): # this sucks
		curSpeed = 0
	else:
		curSpeed = speed

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		look_at(global_transform.origin + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * curSpeed
	target_velocity.z = direction.z * curSpeed
	
	# Smooth the velocity
	velocity.x = lerp(velocity.x, target_velocity.x, (delta * 10)) # magic number 10 :)
	velocity.z = lerp(velocity.z, target_velocity.z, (delta * 10))

	# Moving the Character
	move_and_slide()

#### FIRE
var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

func _input(event):
	if event.is_action_pressed("fire"):
		var bullet_instance = bullet_scene.instantiate()
		get_parent().add_child(bullet_instance)


func _on_area_3d_area_entered(area):
	pass # Replace with function body.
