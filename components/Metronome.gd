extends Node

export var interval := 240 / 3
var timer := interval
var rng = RandomNumberGenerator.new()
onready var explosions = get_node("SFX/Explosions").get_children()

func _ready():
	rng.randomize()

func _physics_process(delta):
	timer = (timer + 1) % interval
	if timer == 0:
		get_tree().call_group('missle', 'trigger')
		var missles = get_tree().get_nodes_in_group('missle')
		if len(missles) > 0:
			var explosion_sound = explosions[randi() % explosions.size()]
			explosion_sound.play()
