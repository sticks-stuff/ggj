extends CharacterBody3D
var direction

func _ready():
	direction = get_parent().get_node("player").get_global_transform().basis.z

var target_velocity = Vector3.ZERO
@export var speed = 14


func _physics_process(delta):
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	print("i am alive")

# func set_forard(rotation):



func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
