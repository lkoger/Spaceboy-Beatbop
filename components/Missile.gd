extends KinematicBody2D

class_name Projectile

var explosion_scene = preload("res://components/Explosion.tscn")

var velocity := Vector2(0, -1)
var speed := 120.0
var triggered := false
export var radius := 32
export var dmg := 1

func _ready():
	add_to_group("missle")
	set_physics_process(false)

func fire():
	set_physics_process(true)

func _physics_process(delta):
	if triggered:
		queue_free()
		_explode()
		
	else:
		move_and_collide(velocity * speed * delta)

func trigger():
	triggered = true

func _explode():
	var explosion = explosion_scene.instance()
	explosion.global_position = global_position
	#explosion.set_layer_and_mask(collision_layer, collision_mask)
	explosion.set_radius(radius)
	explosion.set_dmg(dmg)
	
	get_tree().root.add_child(explosion)
	explosion.activate()
