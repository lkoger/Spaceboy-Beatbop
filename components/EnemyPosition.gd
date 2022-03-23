extends Position2D

var enemy_scene = preload("res://components/Enemy.tscn")
onready var spawn = get_node("Spawn")
onready var active = false
signal deactivated

func spawn():
	var enemy = enemy_scene.instance()
	enemy.global_position = spawn.global_position
	enemy.rotation_degrees = 90.0
	get_tree().root.add_child(enemy)
	enemy.move_to_and_fire(global_position)
	
	enemy.connect("died", self, "disable_active")
	enable_active()

func _on_Timer_timeout():
	spawn()

func enable_active():
	active = true
	

func disable_active():
	active = false
	emit_signal("deactivated", self)
