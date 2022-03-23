extends CanvasLayer

onready var metronome = get_node("/root/Metronome")
var screen_size = 1024 / 2

func _physics_process(delta):
	var timer = metronome.timer
	var interval = metronome.interval
	
	var timer_length = screen_size - (screen_size * (float(timer) / float(interval)))
	
	$Control/BeatBarLeft.rect_size = Vector2(timer_length, 16)
	$Control/BeatBarRight.rect_size = Vector2(timer_length, 16)
