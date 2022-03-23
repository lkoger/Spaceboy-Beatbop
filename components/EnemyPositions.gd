extends Node2D

export onready var enemies_per_wave := 3
var active_positions = null
var inactive_positions = null

func _ready():
	if $inactive.get_child_count() < enemies_per_wave:
		enemies_per_wave = $inactive.get_child_count()
	inactive_positions = $inactive.get_children()
	active_positions = $active.get_children()
	
	for node in inactive_positions:
		node.connect("deactivated", self, "move_to_inactive")
	
func spawn_wave():
	inactive_positions.shuffle()
	for i in range(enemies_per_wave):
		if len(inactive_positions) > 0:
			inactive_positions.back().spawn()
			active_positions.push_back(inactive_positions.pop_back())
	

func _on_SpawnTimer_timeout():
	spawn_wave()

func move_to_inactive(node):
	active_positions.erase(node)
	inactive_positions.push_back(node)
	
