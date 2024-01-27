extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.z += 1
	if Input.is_action_pressed("up"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$Pivot.basis = Basis.looking_at(direction)
		look_at(global_transform.origin + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity
	# move_and_slide()

#### FIRE
var bullet_scene = preload("res://scenes/player/bullet.tscn")

func _input(event):
	if event.is_action_pressed("fire"):
		var bullet_instance = bullet_scene.instantiate()
		get_parent().add_child(bullet_instance)
