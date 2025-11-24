extends CharacterBody2D

@onready var movement_interface: Control = %MovementInterface
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var goal_check_area: Area2D = $GoalCheckArea
@onready var time_left: Timer = %TimeLeft
@export var spikes: TileMapLayer

var listening : bool
var is_finished : bool
var started : bool
var movement_array : Array[String]
const move_amt : int = 16

signal at_end(is_finished: bool)

func _ready() -> void:
	started = false
	is_finished = false
	movement_array = []

# To Start the level just hit space or enter
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and (not started):
		started = true
		listening = true
		# Starts the timer
		time_left.start()
	listen_to_movements()

# Function called to take the input
func listen_to_movements():
	# Can only hold up to 10 direction inputs (how much you need for each level)
	if len(movement_array) < 10 and listening:
		var movement : String = ""
		if Input.is_action_just_pressed("up"):
			movement = "up"
		elif Input.is_action_just_pressed("right"):
			movement = "right"
		elif Input.is_action_just_pressed("left"):
			movement = "left"
		elif Input.is_action_just_pressed("down"):
			movement = "down"
			
		if movement != "":
			movement_array.append(movement)
			movement_interface.add_direction(movement)

# Called after the timer expires and actually moves the player
func move():
	# Iterates through array
	for movement in movement_array:
		if movement == "up":
			velocity = Vector2(0, -move_amt)
		elif movement == "right":
			velocity = Vector2(move_amt, 0)
		elif movement == "left":
			velocity = Vector2(-move_amt, 0)
		elif movement == "down":
			velocity = Vector2(0, move_amt)
		movement_interface.remove_direction()
		character_sprite.animation = movement
		# This function actually moves the player
		switch()
		await get_tree().create_timer(.5).timeout
	at_end.emit(is_finished)

# Moves player and sets spikes if they are in the level
func switch():
	if spikes:
		spikes.set_enabled(!spikes.enabled)
		if spikes.enabled == false:
			# Need to wait till the end of the frame so the spikes actually change BEFORE movement
			await get_tree().process_frame
	
	move_and_collide(velocity)
	
	# Checks if the player is on a spike and resets them if they are
	if spikes:
		var tile_coord = spikes.local_to_map(spikes.to_local(global_position))
		var tile_data = spikes.get_cell_tile_data(tile_coord)
		if tile_data and spikes.is_enabled():
			at_end.emit(is_finished)

# Checks if the player has finished the level
func _on_goal_area_area_entered(area: Area2D) -> void:
	if area.name == "GoalCheckArea":
		is_finished = true

func _on_time_left_timeout() -> void:
	listening = false
	move()
