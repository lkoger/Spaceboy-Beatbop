extends Area2D

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
	$Timer.start()

func _on_Explosion_body_entered(body):
	if body.has_method('_take_damage'):
		body._take_damage(dmg)


func _on_Timer_timeout():
	queue_free()
