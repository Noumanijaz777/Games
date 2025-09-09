extends CharacterBody2D

signal laser(pos,direction)
signal grenade(pos, direction)

var can_laser : bool = true
var can_grenade : bool = true

@export var max_speed:int = 500
var speed :int = max_speed


func hit():
	Globals.health -= 10


func _process(_delta):
	# input
	var direction = Input.get_vector("left","right","forward","back")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	look_at(get_global_mouse_position())
	
	
	if Input.is_action_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$GPUParticles2D.emitting = true
		var laser_markers = $laserstarposition.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		var Player_direction = (get_global_mouse_position() - position).normalized()
		can_laser = false
		$Timer.start()
		
		laser.emit(selected_laser.global_position,Player_direction)
	
	if Input.is_action_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		can_grenade = false
		$grenadetimer.start()
		var laser_markers = $laserstarposition.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		var pos = selected_laser.global_position
		var Player_direction = (get_global_mouse_position() - position).normalized()
		grenade.emit(pos,Player_direction)
	
func _on_timer_timeout() -> void:
	can_laser = true


func _on_grenadetimer_timeout() -> void:
	can_grenade = true
