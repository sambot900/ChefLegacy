extends CharacterBody2D

######################################################
# 	Player
######################################################

#region *Global Declarations
signal state_changed(state_array: Array)
signal reached_interactable
signal where

@export var speed = 400
@export var accel = 20
var command_queue = []
var current_command = null
var finished = false
var orientation_edge_case_r = false
var orientation_edge_case_l = false
var orientation_lock = false

var enabled
var ph_laden
var oh_laden
#endregion

#region *Onready Declarations
@onready var agent: NavigationAgent2D = $NavAg
@onready var c_dd_left: TouchScreenButton = $"../CMDs/c_dd-left"
@onready var c_dd_right: TouchScreenButton = $"../CMDs/c_dd-right"
@onready var c_ms_right: TouchScreenButton = $"../CMDs/c_ms-right"
@onready var c_ms_left: TouchScreenButton = $"../CMDs/c_ms-left"
@onready var c_s_left: TouchScreenButton = $"../CMDs/c_s-left"
@onready var c_s_right: TouchScreenButton = $"../CMDs/c_s-right"
@onready var c_ts_1: TouchScreenButton = $"../CMDs/c_ts-1"
@onready var c_ts_2: TouchScreenButton = $"../CMDs/c_ts-2"
@onready var c_ts_3: TouchScreenButton = $"../CMDs/c_ts-3"
@onready var c_fs_1: TouchScreenButton = $"../CMDs/c_fs-1"
@onready var c_fs_2: TouchScreenButton = $"../CMDs/c_fs-2"
@onready var c_f_left: TouchScreenButton = $"../CMDs/c_f-left"
@onready var c_f_right: TouchScreenButton = $"../CMDs/c_f-right"
@onready var c_t: TouchScreenButton = $"../CMDs/c_t"
@onready var c_t2: TouchScreenButton = $"../CMDs/c_t2"
@onready var c_bob: TouchScreenButton = $"../CMDs/c_bob"
@onready var c_o1: TouchScreenButton = $"../CMDs/c_o1"
@onready var c_o2: TouchScreenButton = $"../CMDs/c_o2"
@onready var c_o3: TouchScreenButton = $"../CMDs/c_o3"
@onready var c_o4: TouchScreenButton = $"../CMDs/c_o4"
@onready var animated_sprite: AnimatedSprite2D = $anim
#endregion


func _ready():
	enabled = true
	ph_laden = false
	oh_laden = false
	finished = true
	emit_state()
	c_dd_left.pressed.connect(self._on_c_dd_left_pressed)
	c_dd_right.pressed.connect(self._on_c_dd_right_pressed)
	c_ms_right.pressed.connect(self._on_c_ms_right_pressed)
	c_ms_left.pressed.connect(self._on_c_ms_left_pressed)
	c_s_left.pressed.connect(self._on_c_s_left_pressed)
	c_s_right.pressed.connect(self._on_c_s_right_pressed)
	c_ts_1.pressed.connect(self._on_c_ts_1_pressed)
	c_ts_2.pressed.connect(self._on_c_ts_2_pressed)
	c_ts_3.pressed.connect(self._on_c_ts_3_pressed)
	c_fs_1.pressed.connect(self._on_c_fs_1_pressed)
	c_fs_2.pressed.connect(self._on_c_fs_2_pressed)
	c_f_left.pressed.connect(self._on_c_f_left_pressed)
	c_f_right.pressed.connect(self._on_c_f_right_pressed)
	c_t.pressed.connect(self._on_c_t_pressed)
	c_t2.pressed.connect(self._on_c_t2_pressed)
	c_bob.pressed.connect(self._on_c_bob_pressed)
	c_o1.pressed.connect(self._on_c_o1_pressed)
	c_o2.pressed.connect(self._on_c_o2_pressed)
	c_o3.pressed.connect(self._on_c_o3_pressed)
	c_o4.pressed.connect(self._on_c_o4_pressed)

func get_state() -> Array:
	var enabled_state = 1 if enabled else 0
	var ph_state = 1 if ph_laden else 0
	var oh_state = 1 if oh_laden else 0
	return [enabled_state, ph_state, oh_state]

func enqueue_command(target: Vector2):
	command_queue.append(target)


#region *OnPress Movement Command Functions
# returns:
# 1. name to identify which command was pressed
# 2. global_position to calculate shortest distance cmd
# 3. queue size to see if checkmark should be displayed
func _on_c_dd_left_pressed():
	name = "dd_left"
	where.emit(name, global_position)

func _on_c_dd_right_pressed():
	name = "dd_right"
	where.emit(name, global_position)

func _on_c_ms_left_pressed():
	name = "ms_left"
	where.emit(name, global_position)

func _on_c_ms_right_pressed():
	name = "ms_right"
	where.emit(name, global_position)

func _on_c_s_left_pressed():
	name = "s_left"
	where.emit(name, global_position)

func _on_c_s_right_pressed():
	name = "s_right"
	where.emit(name, global_position)

func _on_c_ts_1_pressed():
	name = "ts_1"
	where.emit(name, global_position)

func _on_c_ts_2_pressed():
	name = "ts_2"
	where.emit(name, global_position)

func _on_c_ts_3_pressed():
	name = "ts_3"
	where.emit(name, global_position)

func _on_c_f_left_pressed():
	name = "f_1"
	where.emit(name, global_position)

func _on_c_f_right_pressed():
	name = "f_2"
	where.emit(name, global_position)

func _on_c_fs_1_pressed():
	name = "fs_1"
	where.emit(name, global_position)

func _on_c_fs_2_pressed():
	name = "fs_2"
	where.emit(name, global_position)

func _on_c_t_pressed():
	name = "t_1"
	where.emit(name, global_position)

func _on_c_t2_pressed():
	name = "t_2"
	where.emit(name, global_position)

func _on_c_bob_pressed():
	name = "bob"
	where.emit(name, global_position)

func _on_c_o1_pressed():
	name = "o_1"
	where.emit(name, global_position)

func _on_c_o2_pressed():
	name = "o_2"
	where.emit(name, global_position)

func _on_c_o3_pressed():
	name = "o_3"
	where.emit(name, global_position)

func _on_c_o4_pressed():
	name = "o_4"
	where.emit(name, global_position)

#endregion

func _physics_process(delta):
	z_sort()
	
# Assign command from queue
	if finished and command_queue.size() > 0:
	# Report avatar reaching the destination with emit
		if current_command != null: 
			reached_interactable.emit(current_command)
		current_command = command_queue.pop_front()
		orientation_edge_case()
		agent.target_position = current_command
		finished = false
		
# Idle stance
	elif finished and command_queue.size() == 0:
		if current_command != null:
			reached_interactable.emit(current_command)
		current_command = null;
		animated_sprite.play("idle")
	
# Locomotion & Orientation
	if not finished:
		var direction = (agent.get_next_path_position() - global_position).normalized()
		if direction.x > 0 or direction.x < 0 or direction.y > 0 or direction.y < 0:
			animated_sprite.play("L-walk")

# Orientation Common Case
		orientation_common_case(direction)
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()

func _on_nav_ag_navigation_finished():
	finished = true

func edge_case_exists():
# Check for left or right edge case
	if (orientation_edge_case_r or orientation_edge_case_l):
		return true
	else:
		return false

func z_sort():
	if global_position.y > 383:
		z_index = 20
	elif global_position.y > 168 and global_position.y < 384:
		z_index = 12
	elif global_position.y < 160:
		z_index = 5

func orientation_edge_case():
# Reset edge case detection for each command
	orientation_edge_case_r = false
	orientation_edge_case_l = false

	# ---------------------------------------------------------------------------------------------------------
	# R2
	# If you are in general right, and your command is far top-right
	# (global_position.x > 610) and (current_command.x < 653)
	# ---------------------------------------------------------------------------------------------------------
	if current_command.y < 38:
		if (global_position.x > 598) and (current_command.x < 653) and (orientation_edge_case_r == false):
			orientation_edge_case_r = false
			#print("edge case R2 VOID")
	# ---------------------------------------------------------------------------------------------------------
	# R3
	# You are in general right... your command is anywhere under the "top-right area" defined in R2 (above)
	# (global_position.x > 620) and (current_command.x > 652 and current_command.y > 37)
	# ---------------------------------------------------------------------------------------------------------
	elif current_command.y < 122:
		if (global_position.x > 598) and (current_command.x > 652 and current_command.y > 37) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			#print("edge case R3")
	# ---------------------------------------------------------------------------------------------------------
	# R4
	# If you're command is below the topping station
	# You are in general right and command is far right, and your command is below box o buns.
	elif current_command.y > 121:
		if (global_position.x > 620) and (current_command.x > 652 and current_command.y > 80) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			# LOCK RIGHT
			#print("edge case R4")
	# ---------------------------------------------------------------------------------------------------------
	# R1
	# If you're command is below the topping station
	# You in in general right and below the topping station... your command is general right
		if ((global_position.x > 610 and global_position.y > 121) and (current_command.x > global_position.x)) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			#print("edge case R1")

func orientation_common_case(direction):
# Prevent last second jitters as destination is reached
	if not edge_case_exists():
		if global_position.distance_to(current_command) > 10:
			orientation_lock = false
		elif global_position.distance_to(current_command) < 10:
			orientation_lock = true
			
# Change orientation depending on which way avatar is moving

	if orientation_lock == false:
		if direction.x > 0:
			animated_sprite.flip_h = true
		elif direction.x < 0:
			animated_sprite.flip_h = false
	else:
		if orientation_edge_case_l:
			if animated_sprite.flip_h == true:
				animated_sprite.flip_h = false
		elif orientation_edge_case_r:
			if animated_sprite.flip_h == false:
				animated_sprite.flip_h = true

func emit_state():
	var state = get_state()
	state_changed.emit(state)

# Each queued command added emits a request for next coords and those
# coords output below into the enqueue command.
func _on__burgers_go_here(coords):
	if coords != null:
		enqueue_command(coords)
	else:
		print("This obj cmd_count is maxed")

func _on__burgers_state_changed(cmd, state_array):
	if state_array:
		if state_array == [1,0,0]:
			pass
		elif state_array == [1,1,0]:
			pass
		elif state_array == [1,0,1]:
			pass
		elif state_array == [1,1,1]:
			pass
		elif state_array == [0,0,0]:
			pass
		elif state_array == [0,1,0]:
			pass
		elif state_array == [0,0,1]:
			pass
		elif state_array == [0,1,1]:
			pass
			
		print("player:", state_array)
