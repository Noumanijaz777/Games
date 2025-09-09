extends LevelParent
 
@export var outside_scene : PackedScene 

func _on_exit_gate_area_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property($Player,"speed",0,0.5)
	TransitionLayer.change_scene("res://Scenes/level/Outside.tscn")
	
