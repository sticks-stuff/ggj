extends Control

@onready var canvas = $Canvas;
@onready var colorPickerButton = $ColorPickerButton
@onready var fillToggleButton: BaseButton = get_node("CheckButton")
@onready var nextButton: BaseButton = get_node("NextButton")

enum DrawMode {DRAW, FILL}
@export var drawMode = DrawMode.DRAW

var last_button_mask = 0;
var last_position = Vector2(0,0);

var color = Color.INDIAN_RED;

func _ready():
	nextButton.pressed.connect(self._nextButtonPressed)

func _input(event):
	if is_instance_of(event, InputEventMouse):
		if event.button_mask == 1:
			# get draw mode from button
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

func _nextButtonPressed():
	# Get texture
	var game = preload("res://scenes/game_scene.tscn").instantiate();
	game.get_node("BossBody").texture = canvas.
	get_tree().root.add_child(game)
	get_tree().root.remove_child(self)	
