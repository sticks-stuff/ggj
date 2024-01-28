extends Control

@export var healthbar: Range
@export var boss_healthbar: Range

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_player_hp(v):
	healthbar.value = v
	
func update_boss_hp(v):
	boss_healthbar.value = v
