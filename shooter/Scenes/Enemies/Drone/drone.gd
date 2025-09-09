extends CharacterBody2D

var active: bool = false
var speed: int = 0
var max_speed : int = 600
var speed_multiplier :int = 1

var vulnerable : bool = true
var health : int = 50

var explosion_active : bool = false

func _ready() -> void:
	$Explosion.hide()
	$Drone.show()


func _process(delta: float) -> void:
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed * speed_multiplier
		var collision  = move_and_collide(velocity * delta)
		if collision:
			$AnimationPlayer.play("explosion")
			explosion_active = true
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < 400 
			if in_range and "hit" in target:
				target.hit()
	
	
	
func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$HitTimer.start()
		$Drone.material.set_shader_parameter("progress",1)
		$Sounds/HitSound.play()
	if health <= 0:
		$AnimationPlayer.play("explosion")
		explosion_active = true
		
func stop_movement():
	speed_multiplier = 0


func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	var twean = create_tween()
	twean.tween_property(self,"speed",max_speed,6)


func _on_hit_timer_timeout() -> void:
	vulnerable = true
	$Drone.material.set_shader_parameter("progress",0)
