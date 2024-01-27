extends Control

@onready var canvas = $Canvas;
@export var pixel_size = Vector2i(10, 10);

func _ready():
	pass

func _input(event):
	if is_instance_of(event, InputEventMouse):
		var mouse_pos: Vector2 = event.position;
		print(mouse_pos);
