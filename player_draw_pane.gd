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
			canvas.draw_pixel_line(last_position, event.position, Color.RED)
		last_position = event.position;
		last_button_mask = event.button_mask;


func _process(delta):
	queue_redraw()
