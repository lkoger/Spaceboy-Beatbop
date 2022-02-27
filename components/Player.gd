extends KinematicBody2D

var missle_scene = preload("res://components/Missile.tscn")

export var ui_path : NodePath = ""
var ui = null
var reload_progress = null

var velocity := Vector2.ZERO
var speed := 300.0
var acceleration := 0.2
var state = "idle"
var health := 1

var cooldown_interval = 60
var cooldown_timer = 0

var fire_input_buffer = 15
var fire_input_timer = 0


func _ready():
	ui = get_node(ui_path)
	reload_progress = ui.get_node("Control/ReloadProgress")

func _process(delta):
	velocity = Vector2.ZERO
	var new_state = 'idle'
	
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		new_state = 'move-left'
	elif Input.is_action_pressed("right"):
		velocity.x += 1.0
		new_state = 'move-right'
		
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	elif Input.is_action_pressed("down"):
		velocity.y += 1.0
	
	_change_state(new_state)
	
	velocity = velocity.normalized() * speed

# TODO(koger): Movement is snappy. Is this desirable? Do we want acceleration,
# sliding, and other effects that make it feel more slugish?
func _physics_process(delta):
	fire_input_timer = max(0, fire_input_timer-1)
	cooldown_timer = max(0, cooldown_timer-1)
	
	if Input.is_action_just_pressed("fire"):
		fire_input_timer = fire_input_buffer
	
	if fire_input_timer > 0:
		if cooldown_timer == 0:
			cooldown_timer = cooldown_interval
			_fire()
	
	reload_progress.value = 100 - ((float(cooldown_timer) / float(cooldown_interval)) * 100)
	
	move_and_slide(velocity)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		if state == 'move-right' or state == 'move-left':
			$Sprite.scale = Vector2(0.75, 1)
		else:
			$Sprite.scale = Vector2(1, 1)
		#$AnimatedSprite.play(state)

func _fire():
	var missle = missle_scene.instance()
	missle.global_position = $GunPosition.global_position
	get_tree().root.add_child(missle)
	missle.fire()

func _take_damage(dmg):
	health -= dmg
	print(health)

func handle_explosion(projectile):
	assert(projectile is Projectile)
	var radius = projectile.radius
	var dist = global_position.distance_to(projectile.global_position)
	if dist <= radius:
		_take_damage(projectile.dmg)
