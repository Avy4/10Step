extends Node2D
@onready var movement_interface: Control = %MovementInterface
@onready var time_left: Timer = %TimeLeft
@export var next_level: String

func _on_character_at_end(is_finished: bool) -> void:
	print("ran")
	if is_finished:
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().call_deferred("reload_current_scene")
	

func _physics_process(_delta: float) -> void:
	if not time_left.is_stopped():
		var timeleft = (1 - (time_left.time_left/5)) * 100
		movement_interface.update_time(timeleft)

func _on_time_left_timeout() -> void:
	pass
