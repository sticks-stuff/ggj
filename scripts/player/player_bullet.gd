extends CharacterBody3D
var direction = Vector3.ZERO

func _ready():
	direction = get_parent().get_node("player").get_global_transform().basis.z
	position = get_parent().get_node("player").position

var target_velocity = Vector3.ZERO
@export var speed = -21 # negative bc for some reason the direction we get from the parent is wrong?

func _physics_process(delta):
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
