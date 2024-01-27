extends Control

@onready var canvas = get_node("Canvas");
@onready var colorPickerButton = $ColorPickerButton
@export var pixel_size = Vector2i(10, 10);

enum DrawMode {DRAW, FILL}
@export var drawMode = DrawMode.DRAW

var last_button_mask = 0;
var last_position = Vector2(0,0);

var color = Color.RED;

func _ready():
	pass

func _input(event):
	if is_instance_of(event, InputEventMouse):
		if event.button_mask == 1:
			match drawMode:
				DrawMode.DRAW:
					if last_button_mask == 1:
						canvas.draw_pixel_line(last_position, event.position, colorPickerButton.color)
				DrawMode.FILL:
					canvas.draw_pixel_fill(event.position, colorPickerButton.color)
		last_position = event.position;
		last_button_mask = event.button_mask;

func setDrawMode(newDrawMode: DrawMode) -> void:
	drawMode = newDrawMode

func _process(delta):
	queue_redraw()
