tool
extends RayCast2D

export (bool) var editor_process := true setget set_editor_process
export (bool) var is_casting := true setget set_is_casting
export (int) var damage := 1

# Rotate configuration
export (bool) var rotate := false
export (float, 360) var clockwise_extents_degrees := 0.0
export (float, 360) var counter_clockwise_extents_degrees := 0.0
export (float, 1, 360) var deg_per_sec := 1
var initial_orientation_degrees := 0.0
var rotate_clockwise := true

# Timed Laser Configuraton
export (bool) var timed := false
export (float) var emission_time := 0.0
export (float) var rest_time := 0.0
export (float) var power_up_time := 0.0

func _ready():
	set_physics_process(false)
	$OutLine.points[1] = Vector2.ZERO
	$CenterLine.points[1] = Vector2.ZERO
	set_is_casting(is_casting)
		
	if rotate:
		initial_orientation_degrees = rotation_degrees
		$RotateTween.connect("tween_completed", self, "_change_direction")
		$PauseTimer.connect("timeout", self, "_start_rotating")
		$PauseTimer.start()
	
	
	if timed:
		$EmissionTimers/EmitTime.connect("timeout", self, "_rest")
		$EmissionTimers/RestTime.connect("timeout", self, "_power_up")
		$EmissionTimers/PowerUpTime.connect("timeout", self, "_emit")
		
		if not is_casting:
			_power_up()
		else:
			$EmissionTimers/EmitTime.start(emission_time)

func _physics_process(delta: float) -> void:
	var cast_point := cast_to
	force_raycast_update()
	
	$CollidingParticles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollidingParticles.global_rotation = get_collision_normal().angle()
		$CollidingParticles.position = cast_point
		var collider = get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
	
	$OutLine.points[1] = cast_point
	$CenterLine.points[1] = cast_point
	
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5

	
func set_editor_process(value: bool) -> void:
	editor_process = value
	
	if not Engine.editor_hint:
		return
	
	$PauseTimer.set_paused(value)
	for timer in $EmissionTimers.get_children():
		timer.set_paused(value)
		
	set_physics_process(value)
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$EmittingParticles.emitting = is_casting
	$BeamParticles.emitting = is_casting
	if is_casting:
		appear()
	else:
		$CollidingParticles.emitting = false
		disappear()
	
	set_physics_process(is_casting)

func appear() -> void:
	$OutLine/Tween.stop_all()
	$OutLine/Tween.interpolate_property($OutLine, "width", 0.0, 10.0, 0.2)
	$OutLine/Tween.start()
	
	$CenterLine/Tween.stop_all()
	$CenterLine/Tween.interpolate_property($CenterLine, "width", 0.0, 2.0, 0.2)
	$CenterLine/Tween.start()

func disappear() -> void:
	$OutLine/Tween.stop_all()
	$OutLine/Tween.interpolate_property($OutLine, "width", 10.0, 0.0, 0.1)
	$OutLine/Tween.start()
	
	$CenterLine/Tween.stop_all()
	$CenterLine/Tween.interpolate_property($CenterLine, "width", 2.0, 0.0, 0.1)
	$CenterLine/Tween.start()

### Rotate Methods
func _start_rotating():
	if Engine.editor_hint and not editor_process:
		return
		
	if rotate_clockwise:
		var start = rotation_degrees
		var end = initial_orientation_degrees + clockwise_extents_degrees
		var duration = abs(end - start) / deg_per_sec
		$RotateTween.interpolate_property(self, "rotation_degrees", start, end, duration)
	else:
		var start = rotation_degrees
		var end = initial_orientation_degrees - counter_clockwise_extents_degrees
		var duration = abs(start - end) / deg_per_sec
		$RotateTween.interpolate_property(self, "rotation_degrees", start, end, duration)
	$RotateTween.start()

func _change_direction(object, key):
	rotate_clockwise = not rotate_clockwise
	$PauseTimer.start()
	
### Timed Laser Methods
func _power_up():
	$EmittingParticles.emitting = true
	$EmissionTimers/PowerUpTime.start(power_up_time)

func _emit():
	set_is_casting(true)
	$EmissionTimers/EmitTime.start(emission_time)

func _rest():
	set_is_casting(false)
	$EmissionTimers/RestTime.start(rest_time)







