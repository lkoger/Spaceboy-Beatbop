extends Area2D

onready var metronome = get_node("/root/Metronome")
var dmg := 1
var active := false

func _ready():
	monitoring = active

func _physics_process(delta):
	monitoring = active
	$AnimatedSprite.playing = active

func set_layer_and_mask(layer, mask):
	collision_layer = layer
	collision_mask = mask

func set_radius(radius):
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	
	collision_shape.shape = shape
	add_child(collision_shape)

func set_dmg(dmg):
	self.dmg = dmg

func activate():
	active = true
	var rand = metronome.rng.randi_range(0, 1)

	# Randomly play one of the explosion animations
	if rand == 0:
		$AnimatedSprite.play('explosion0')
	else:
		$AnimatedSprite.play('explosion1')

func _on_Explosion_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(dmg)

func _on_Explosion_area_entered(area):
	if area.has_method('take_damage'):
		area.take_damage(dmg)

func _on_Timer_timeout():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing = false
	queue_free()


