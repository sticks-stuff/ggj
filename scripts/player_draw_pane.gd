extends Control

@onready var canvas = $Canvas;
@export var pixel_size = Vector2i(10, 10);

var last_button_mask = 0;
var last_position = Vector2(0,0);

func _ready():
	pass

func _input(event):
	if is_instance_of(event, InputEventMouse):
		if last_button_mask == 1 and event.button_mask == 1:
			print("draw line between:", last_position, event.position)
		last_position = event.position;
		last_button_mask = event.button_mask;

func _draw():
	draw_rect(Rect2(0, 0, 100, 100), Color.RED)

func _process(delta):
	queue_redraw()
