extends Area2D

var target = null
var rotation_speed = 1.0
signal died

func _physics_process(delta):
	update_aim(delta)

func move_to_and_fire(target_pos):
	$MovementTween.interpolate_property(self, "global_position", global_position, target_pos, 2.0, Tween.TRANS_SINE)
	$MovementTween.start()

func _arrived_at_destination(object, key):
	var player_container = get_tree().get_nodes_in_group("player")
	if (len(player_container) > 0):
		var player = player_container[0]
		set_target(player)

func set_target(player):
	target = player

func update_aim(delta):
	if target:
		var direction = global_position.direction_to(target.global_position)
		var angle_delta = $BeamPosition.position.angle_to(to_local(target.global_position))
		if abs(rad2deg(angle_delta)) > 1:
			var angle_adjustment = clamp(angle_delta, -rotation_speed, rotation_speed)
			global_rotation += angle_adjustment * delta

func take_damage(dmg):
	emit_signal("died")
	queue_free()
