extends CharacterBody2D

#region *Global Declarations
@export var speed = 300
@export var accel = 20
var command_queue = []
var command_array
var current_command = null
var current_command_middle = null
var finished = false
var orientation_edge_case_r = false
var orientation_edge_case_l = false
var orientation_lock = false
signal reached_interactable
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
	finished = true
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
	print("Round node ready")

func enqueue_command(target_pos_array: Array):
	if command_queue.size() > 0 and command_queue[-1] != target_pos_array:
		command_queue.append(target_pos_array)
	elif command_queue.size() == 0:
		command_queue.append(target_pos_array)
		print("Current queue: ", command_queue)
	else:
		pass

#region *OnPress Movement Command Functions

func _on_c_dd_left_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 337
	var x_range = 30
	var y_common = 423
	# -----------------------------------------
	var travel_distance_left = x_mid-x_range
	var travel_distance_right = x_mid+x_range
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_dd_right_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 409		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var y_common = 423	# common case value
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_ms_left_pressed():
	# -----------------------------------------
	# ADJUSTMENTS	
	var x_mid = 554		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var y_common = 14	# common case value
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_ms_right_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 625		# command plane surface mid-point (x or y)
	var reach = 24		# how far can avatar reach
	var y_common = 14	# common case value
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_s_left_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 348		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var y_common = -9	# common case value
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_s_right_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 474		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var y_common = -9	# common case value
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	enqueue_command([Vector2(travel_distance_left, y_common), Vector2(x_mid, y_common), Vector2(travel_distance_right, y_common)])

func _on_c_ts_1_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 350
	var y_mid = 140
	var reach = 30
	var x_common = 238
	var y_common = 55
	var y_common2 = 180
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	
	var top = [Vector2(travel_distance_left, y_common),Vector2(x_mid, y_common),Vector2(travel_distance_right, y_common)]
	var left = [Vector2(x_common, travel_distance_up),Vector2(x_common, y_mid),Vector2(x_common, travel_distance_down)]
	var bottom = [Vector2(travel_distance_left, y_common2),Vector2(x_mid, y_common2),Vector2(travel_distance_right, y_common2)]
	enqueue_command(top + left + bottom)

func _on_c_ts_2_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 437
	var y_mid = 140
	var reach = 30
	var y_common = 55
	var y_common2 = 180
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	
	var top = [Vector2(travel_distance_left, y_common),Vector2(x_mid, y_common),Vector2(travel_distance_right, y_common)]
	var bottom = [Vector2(travel_distance_left, y_common2),Vector2(x_mid, y_common2),Vector2(travel_distance_right, y_common2)]
	enqueue_command(top + bottom)

func _on_c_ts_3_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var x_mid = 525
	var y_mid = 138
	var reach = 30
	var x_common = 612
	var y_common = 55
	var y_common2 = 180
	# -----------------------------------------
	var travel_distance_left = x_mid-reach
	var travel_distance_right = x_mid+reach
	var travel_distance_up = (y_mid-(reach))
	var travel_distance_down = (y_mid+reach)
	
	var top = [Vector2(travel_distance_left, y_common),Vector2(x_mid, y_common),Vector2(travel_distance_right, y_common)]
	var right = [Vector2(x_common, travel_distance_up),Vector2(x_common, y_mid),Vector2(x_common, y_mid+6)]
	var bottom = [Vector2(travel_distance_left, y_common2),Vector2(x_mid, y_common2),Vector2(travel_distance_right, y_common2)]
	enqueue_command(top + right + bottom)

func _on_c_f_left_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 148		# command plane surface mid-point (x or y)
	var reach = 15		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])


func _on_c_f_right_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 200		# command plane surface mid-point (x or y)
	var reach = 15		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])

func _on_c_fs_1_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 295		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])
	
func _on_c_fs_2_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 359		# command plane surface mid-point (x or y)
	var reach = 30		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])

func _on_c_t_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 453		# command plane surface mid-point (x or y)
	var reach = 25		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])
	
func _on_c_t2_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 519		# command plane surface mid-point (x or y)
	var reach = 25		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])

func _on_c_bob_pressed():
	# -----------------------------------------
	# ADJUSTMENTS
	var y_mid = 46		# command plane surface mid-point (x or y)
	var reach = 25		# how far can avatar reach
	var x_common = 653	# common case value
	# -----------------------------------------
	var travel_distance_up = y_mid-reach
	var travel_distance_down = y_mid+reach
	enqueue_command([Vector2(x_common, travel_distance_up), Vector2(x_common, y_mid), Vector2(x_common, travel_distance_down)])

func _on_c_o1_pressed():
	print("c_o1", global_position)
	enqueue_command([Vector2(292, 572)])

func _on_c_o2_pressed():
	print("c_o2", global_position)
	enqueue_command([Vector2(424, 572)])

func _on_c_o3_pressed():
	print("c_o3", global_position)
	enqueue_command([Vector2(558, 572)])

func _on_c_o4_pressed():
	print("c_o4", global_position)
	enqueue_command([Vector2(686, 572)])
#endregion

func _physics_process(delta):
	z_sort()
	
	if finished:
		if current_command != null:
			reached_interactable.emit(current_command)
	
# Assign command from queue
	if finished and command_queue.size() > 0:
		current_command = command_seek()
		orientation_edge_case()
		agent.target_position = current_command
		print("CMD CHOSEN: ",current_command)
		
		finished = false
		
# Idle stance
	elif finished and command_queue.size() == 0:
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

func command_seek():
# Get next command in queue
	command_array = command_queue.pop_front()
# Find shortest distance destination
	if command_array.size() > 1:
		var shortest_distance = INF
		var closest_command = null
		for command in command_array:
			var distance = global_position.distance_to(command)
			if distance < shortest_distance:
				shortest_distance = distance
				closest_command = command
		return closest_command
# If only one destination available from command
	else:
		return command_array[0]

func z_sort():
	if global_position.y > 383:
		z_index = 12
	elif global_position.y > 168 and global_position.y < 384:
		z_index = 10
	elif global_position.y < 160:
		z_index = 4
	else:
		z_index = 1

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
			print("edge case R2 VOID")
	# ---------------------------------------------------------------------------------------------------------
	# R3
	# You are in general right... your command is anywhere under the "top-right area"
	# (global_position.x > 620) and (current_command.x > 652 and current_command.y > 37)
	# ---------------------------------------------------------------------------------------------------------
	elif current_command.y < 122:
		if (global_position.x > 598) and (current_command.x > 652 and current_command.y > 37) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			print("edge case R3")
	# ---------------------------------------------------------------------------------------------------------
	# R4
	# If you're command is below the topping station
	# You are in general right and command is far right, and your command is below box o buns.
	elif current_command.y > 121:
		if (global_position.x > 620) and (current_command.x > 652 and current_command.y > 80) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			# LOCK RIGHT
			print("edge case R4")
	# ---------------------------------------------------------------------------------------------------------
	# R1
	# If you're command is below the topping station
	# You in in general right and below the topping station... your command is general right
		if ((global_position.x > 610 and global_position.y > 121) and (current_command.x > global_position.x)) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			print("edge case R1")

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
