extends CanvasLayer

onready var metronome = get_node("/root/Metronome")
var screen_size = 1024

func _physics_process(delta):
	var timer = metronome.timer
	var interval = metronome.interval
	
	var timer_length = screen_size * (float(timer) / float(interval))
	$Control/ColorRect.rect_size = Vector2(timer_length, 16)
