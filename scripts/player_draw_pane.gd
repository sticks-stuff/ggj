extends Control

@onready var canvas = get_node("Canvas");
@onready var colorPickerButton = $ColorPickerButton
@onready var fillToggleButton: CheckButton = get_node("CheckButton")

enum DrawMode {DRAW, FILL}
@export var drawMode = DrawMode.DRAW

var last_button_mask = 0;
var last_position = Vector2(0,0);

var color = Color.INDIAN_RED;

func _ready():
	pass

func _input(event):
	if is_instance_of(event, InputEventMouse):
		if event.button_mask == 1:
			
			# get draw mode from button
			#drawMode = fillToggleButton.pressed ? DrawMode.FILL : DrawMode.DRAW
			drawMode = DrawMode.FILL if fillToggleButton.button_pressed else DrawMode.DRAW
			
			match drawMode:
				DrawMode.DRAW:
					if last_button_mask == 1:
						canvas.draw_pixel_line(last_position, event.position, colorPickerButton.color)
				DrawMode.FILL:
					canvas.draw_pixel_fill(event.position, colorPickerButton.color)
		last_position = event.position;
		last_button_mask = event.button_mask;

func _process(delta):
	queue_redraw()
