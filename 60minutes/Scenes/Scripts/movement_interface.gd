extends Control
@onready var movement_container: HBoxContainer = $PanelContainer/MovementContainer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func add_direction(direction):
	var new_direction = TextureRect.new()
	new_direction.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	if direction == "up":
		new_direction.texture = load("res://Assets/arrows/arrow_up_shaded.png")
	elif direction == "down":
		new_direction.texture = load("res://Assets/arrows/arrow_down_shaded.png")
	elif direction == "left":
		new_direction.texture = load("res://Assets/arrows/arrow_left_shaded.png")
	elif direction == "right":
		new_direction.texture = load("res://Assets/arrows/arrow_right_shaded.png")
	movement_container.add_child(new_direction)

func remove_direction():
	movement_container.get_child(0).queue_free()

func update_time(timeleft : float):
	texture_progress_bar.value = timeleft
