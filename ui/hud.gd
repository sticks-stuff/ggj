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
	#var startscene = preload("res://scenes/player_draw_pane.tscn").instantiate();
	get_tree().change_scene_to_file("res://scenes/player_draw_pane.tscn")
