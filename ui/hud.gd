extends Control

@export var healthbar: Range
@export var boss_healthbar: Range
@export var death_screen: Control
@export var playagain_button: BaseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	playagain_button.pressed.connect(self._play_again)
	death_screen.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_player_hp(v):
	healthbar.value = v
	if v <= 0:
		show_death_screen()
	
func update_boss_hp(v):
	boss_healthbar.value = v
	
func  show_death_screen():
	death_screen.visible = true;
	
func _play_again():
	var root_node = get_tree().get_root()
	var scene_node = root_node.get_node("Node3D")
	scene_node.queue_free()
	
	var new_scene_resource = load("res://scenes/player_draw_pane.tscn") # Load the new level from disk
	var new_scene_node = new_scene_resource.instantiate() # Create an actual node of it for the game to use
	root_node.add_child(new_scene_node) # Add to the tree so the level starts processing
