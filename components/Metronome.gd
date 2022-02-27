extends Node

export var interval := 240
var timer := interval

func _physics_process(delta):
	timer = (timer + 1) % interval
	if timer == 0:
		get_tree().call_group('missle', 'trigger')
