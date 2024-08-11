extends CharacterBody2D

#region *Global Declarations
@export var speed = 300
@export var accel = 20
var command_queue = []
var command_array
var current_command = null
var finished = false
var orientation_edge_case_r = false
var orientation_edge_case_l = false
var orientation_lock = false
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
	c_bob.pressed.connect(self._on_c_bob_pressed)
	c_o1.pressed.connect(self._on_c_o1_pressed)
	c_o2.pressed.connect(self._on_c_o2_pressed)
	c_o3.pressed.connect(self._on_c_o3_pressed)
	c_o4.pressed.connect(self._on_c_o4_pressed)
	print("Round node ready")

func enqueue_command(target_pos_array: Array):
	if command_queue.size() > 0 and command_queue[-1] != target_pos_array:
		command_queue.append(target_pos_array)
		print("Command enqueued: ", target_pos_array)
		print("Current queue: ", command_queue)
	elif command_queue.size() == 0:
		print("Adding: ", target_pos_array)
		command_queue.append(target_pos_array)
		print("Current queue: ", command_queue)
	else:
		print("Dupe")

#region *OnPress Movement Command Functions

func _on_c_dd_left_pressed():
	print("c_dd_left pressed at global position: ", global_position)
	enqueue_command([Vector2(311, 423), Vector2(343, 423), Vector2(374, 423)])


func _on_c_dd_right_pressed():
	print("c_dd_right pressed at global position: ", global_position)
	enqueue_command([Vector2(387, 423), Vector2(414, 423), Vector2(448, 423)])

func _on_c_ms_left_pressed():
	print("c_ms_left pressed at global position: ", global_position)
	enqueue_command([Vector2(600, -10),Vector2(568, -9)])

func _on_c_ms_right_pressed():
	print("c_ms_right pressed at global position: ", global_position)
	enqueue_command([Vector2(645, -9)])

func _on_c_s_left_pressed():
	print("c_s_left pressed at global position: ", global_position)
	enqueue_command([Vector2(290, -9),Vector2(335, -9),Vector2(400, -9)])

func _on_c_s_right_pressed():
	print("c_s_right pressed at global position: ", global_position)
	enqueue_command([Vector2(435, -9),Vector2(480, -9),Vector2(502, -9)])

func _on_c_ts_1_pressed():
	print("c_ts_1 pressed at global position: ", global_position)
	var top = [Vector2(317, 55),Vector2(352, 55),Vector2(380, 55)]
	var left = [Vector2(316, 145),Vector2(316, 123),Vector2(316, 140)]
	var bottom = [Vector2(317, 180),Vector2(352, 180),Vector2(380, 180)]
	enqueue_command(top + left + bottom)

func _on_c_ts_2_pressed():
	print("c_ts_2 pressed at global position: ", global_position)
	var top = [Vector2(436, 55),Vector2(469, 55),Vector2(408, 55)]
	var bottom = [Vector2(436, 180),Vector2(469, 180),Vector2(408, 180)]
	enqueue_command(top + bottom)

func _on_c_ts_3_pressed():
	print("c_ts_3 pressed at global position: ", global_position)
	var top = [Vector2(527, 55),Vector2(558, 55),Vector2(490, 55)]
	var right = [Vector2(610, 100),Vector2(610, 130),Vector2(610, 150)]
	var bottom = [Vector2(525, 180),Vector2(530, 180),Vector2(527, 180)]
	enqueue_command(top + right + bottom)

func _on_c_f_left_pressed():
	print("c_f_left pressed at global position: ", global_position)
	enqueue_command([Vector2(653, 187),Vector2(720, 198)])

func _on_c_f_right_pressed():
	print("c_f_right pressed at global position: ", global_position)
	enqueue_command([Vector2(653, 255),Vector2(720, 254)])

func _on_c_fs_1_pressed():
	print("c_fs_1 pressed at global position: ", global_position)
	enqueue_command([Vector2(653, 300)])
	
func _on_c_fs_2_pressed():
	print("c_fs_2 pressed at global position: ", global_position)
	enqueue_command([Vector2(653, 360)])

func _on_c_t_pressed():
	print("c_t pressed at global position: ", global_position)
	enqueue_command([Vector2(653,434),Vector2(653,450),Vector2(653,474)])

func _on_c_bob_pressed():
	print("c_bob pressed at global position: ", global_position)
	enqueue_command([Vector2(653,84)])

func _on_c_o1_pressed():
	print("c_o1 pressed at global position: ", global_position)
	enqueue_command([Vector2(292, 572)])

func _on_c_o2_pressed():
	print("c_o2 pressed at global position: ", global_position)
	enqueue_command([Vector2(424, 572)])

func _on_c_o3_pressed():
	print("c_o3 pressed at global position: ", global_position)
	enqueue_command([Vector2(558, 572)])

func _on_c_o4_pressed():
	print("c_o4 pressed at global position: ", global_position)
	enqueue_command([Vector2(686, 572)])
#endregion

func _physics_process(delta):
	z_sort()
	
# Assign command from queue
	if finished and command_queue.size() > 0:
		current_command = command_seek()
		agent.target_position = current_command
		
		orientation_edge_case()
		
		finished = false
		
# Idle stance
	elif finished and command_queue.size() == 0:
		animated_sprite.play("idle")
	
# Locomotion & Orientation
	if not finished:
		animated_sprite.play("L-walk")
		var direction = (agent.get_next_path_position() - global_position).normalized()

# Orientation Common Case
		orientation_common_case(direction)
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()

func _on_nav_ag_navigation_finished():
	finished = true

func _on_nav_ag_target_reached():
	pass

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
		z_index = 11
	elif global_position.y > 168 and global_position.y < 384:
		z_index = 9
	elif global_position.y < 160:
		z_index = 4
	else:
		z_index = 1

func orientation_edge_case():
# Reset edge case detection for each command
	orientation_edge_case_r = false
	orientation_edge_case_l = false
	
	# If target destination is above BOX OF BUNS
	if current_command.y < 38:
		if (global_position.x > 610) and (current_command.x > 611) and (orientation_edge_case_r == false):
			orientation_edge_case_r = false
			print("edge case VOID R3")
	# If target destination is below
	elif current_command.y < 122:
		if (global_position.x > 620) and (current_command.x > 652 and current_command.y > 38) and (orientation_edge_case_r == false):
			orientation_force_right()
			print("edge case VOID R4")
	elif current_command.y > 121:
		if (global_position.x > 620) and (current_command.x > 652 and current_command.y > 80) and (orientation_edge_case_r == false):
			orientation_force_right()
			print("R5")
		if ((global_position.x > 610 and global_position.y > 121) and (current_command.x > 611)) and (orientation_edge_case_r == false):
			orientation_force_right()
			print("edge case R")
		if (global_position.x > 515 and (global_position.x < 622)) and (current_command.x > 515 and (current_command.x < 622)) and (orientation_edge_case_l == false):
			orientation_edge_case_l = true
			print("edge case L")
	

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
			
func orientation_force_right():
	animated_sprite.flip_h = true
	orientation_edge_case_r = true
