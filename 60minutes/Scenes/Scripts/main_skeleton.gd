extends Node2D
@onready var movement_interface: Control = %MovementInterface
@onready var time_left: Timer = %TimeLeft
@export var next_level: String

# Waits for a signal from the character script to either change to the next level or reset the level
func _on_character_at_end(is_finished: bool) -> void:
	if is_finished:
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().call_deferred("reload_current_scene")

# Handles changing the timer
func _physics_process(_delta: float) -> void:
	if not time_left.is_stopped():
		var timeleft = (1 - (time_left.time_left/5)) * 100
		movement_interface.update_time(timeleft)
