extends CharacterBody3D
@export var speed = 15
@export var max_speed = 30  # Maximum speed
@export var fireAtPlayer = true
var forward_direction

func _physics_process(delta):
	if fireAtPlayer == false:
		forward_direction = transform.basis.z
	else:
		forward_direction = get_parent().transform.basis.z
	var target_velocity = forward_direction * max_speed  # Target velocity is forward direction times max speed

	# Lerp the current velocity to the target velocity
	velocity = lerp(velocity, target_velocity, delta * speed)

	# Apply the velocity
	move_and_slide()


func _on_area_3d_area_entered(area):
	if area.is_in_group("player"):
		queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _on_area_3d_body_entered(body):
	if body.name != "world_collision":
		queue_free()
