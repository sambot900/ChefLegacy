extends CharacterBody2D

@export var speed = 300
@export var accel = 20

var command_queue = []
var command_array
var current_command = null
var finished = false
var orientation_edge_case_r = false
var orientation_edge_case_l = false
var edge_case_exists = false
var orientation_lock = false

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
@onready var c_fs_3: TouchScreenButton = $"../CMDs/c_fs-3"
@onready var c_f_left: TouchScreenButton = $"../CMDs/c_f-left"
@onready var c_f_right: TouchScreenButton = $"../CMDs/c_f-right"
@onready var c_t: TouchScreenButton = $"../CMDs/c_t"
@onready var c_bob: TouchScreenButton = $"../CMDs/c_bob"
@onready var c_o1: TouchScreenButton = $"../CMDs/c_o1"
@onready var c_o2: TouchScreenButton = $"../CMDs/c_o2"
@onready var c_o3: TouchScreenButton = $"../CMDs/c_o3"
@onready var c_o4: TouchScreenButton = $"../CMDs/c_o4"

@onready var animated_sprite: AnimatedSprite2D = $anim

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
	c_fs_3.pressed.connect(self._on_c_fs_3_pressed)
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


func _on_c_dd_left_pressed():
	print("c_dd_left pressed at global position: ", global_position)
	enqueue_command([Vector2(640, 241), Vector2(678, 241)])


func _on_c_dd_right_pressed():
	print("c_dd_right pressed at global position: ", global_position)
	enqueue_command([Vector2(702, 241),Vector2(745, 241)])

func _on_c_ms_left_pressed():
	print("c_ms_left pressed at global position: ", global_position)
	enqueue_command([Vector2(920, 241),Vector2(973, 241)])

func _on_c_ms_right_pressed():
	print("c_ms_right pressed at global position: ", global_position)
	enqueue_command([Vector2(989, 241),Vector2(1042, 241)])

func _on_c_s_left_pressed():
	print("c_s_left pressed at global position: ", global_position)
	enqueue_command([Vector2(1078, 250),Vector2(1147, 250)])

func _on_c_s_right_pressed():
	print("c_s_right pressed at global position: ", global_position)
	enqueue_command([Vector2(1176, 250),Vector2(1220, 250)])

func _on_c_ts_1_pressed():
	print("c_ts_1 pressed at global position: ", global_position)
	enqueue_command([Vector2(1222, 325)])

func _on_c_ts_2_pressed():
	print("c_ts_2 pressed at global position: ", global_position)
	enqueue_command([Vector2(1222, 402)])

func _on_c_ts_3_pressed():
	print("c_ts_3 pressed at global position: ", global_position)
	enqueue_command([Vector2(1222, 468)])

func _on_c_f_left_pressed():
	print("c_f_left pressed at global position: ", global_position)
	enqueue_command([Vector2(971, 468),Vector2(1000, 468)])

func _on_c_f_right_pressed():
	print("c_f_right pressed at global position: ", global_position)
	enqueue_command([Vector2(1068, 468),Vector2(1029, 468)])

func _on_c_fs_3_pressed():
	print("c_fs_3 pressed at global position: ", global_position)
	enqueue_command([Vector2(898, 468),Vector2(842, 468)])

func _on_c_fs_2_pressed():
	print("c_fs_2 pressed at global position: ", global_position)
	enqueue_command([Vector2(815, 468),Vector2(778, 468)])

func _on_c_fs_1_pressed():
	print("c_fs_1 pressed at global position: ", global_position)
	enqueue_command([Vector2(730, 468),Vector2(698, 468)])

func _on_c_t_pressed():
	print("c_t pressed at global position: ", global_position)
	enqueue_command([Vector2(766, 437),Vector2(738, 437),Vector2(706, 437),Vector2(658, 367),Vector2(658, 326),Vector2(706, 257),Vector2(736, 257),Vector2(769, 257)])

func _on_c_bob_pressed():
	print("c_bob pressed at global position: ", global_position)
	enqueue_command([Vector2(972, 437),Vector2(933, 437),Vector2(897, 437),Vector2(0, 367),Vector2(1033, 392),Vector2(1029, 357),Vector2(1026, 317),Vector2(936, 267),Vector2(889, 267)])

func _on_c_o1_pressed():
	print("c_o1 pressed at global position: ", global_position)
	enqueue_command([Vector2(621, 230)])

func _on_c_o2_pressed():
	print("c_o2 pressed at global position: ", global_position)
	enqueue_command([Vector2(621, 325)])

func _on_c_o3_pressed():
	print("c_o3 pressed at global position: ", global_position)
	enqueue_command([Vector2(621, 431)])

func _on_c_o4_pressed():
	print("c_o4 pressed at global position: ", global_position)
	enqueue_command([Vector2(621, 470)])


func _physics_process(delta):
	
# Z-sort
	if global_position.y > 372:
		z_index = 4
	else:
		z_index = 1
	
# Assign command from queue
	if finished and command_queue.size() > 0:
		command_array = command_queue.pop_front()
		if command_array.size() > 1:
			var shortest_distance = INF
			var closest_command = null
			for command in command_array:
				var distance = global_position.distance_to(command)
				if distance < shortest_distance:
					shortest_distance = distance
					closest_command = command
			current_command = closest_command
		else:
			print("only one cmd")
			current_command = command_array[0]
		agent.target_position = current_command
		
# Orientation Edge Case Determination
		orientation_edge_case_r = false
		orientation_edge_case_l = false
		edge_case_exists = false
		
		if (global_position.x > 1220) and (current_command.x > 1220 and current_command.y > 255) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
		elif (global_position.x < 625) and (current_command.x < 625) and (orientation_edge_case_l == false):
			orientation_edge_case_l = true

		if (orientation_edge_case_r or orientation_edge_case_l):
			edge_case_exists = true
		
		finished = false
		
# Idle stance
	elif finished and command_queue.size() == 0:
		animated_sprite.play("idle")
	
# Locomotion & Orientation
	if not finished:
		animated_sprite.play("L-walk")
		var direction = (agent.get_next_path_position() - global_position).normalized()

# Orientation Common Case
		if not edge_case_exists:
			if global_position.distance_to(current_command) > 10:
				orientation_lock = false
			elif global_position.distance_to(current_command) < 10:
				orientation_lock = true

		if orientation_lock == false:
			if direction.x > 0:
				animated_sprite.flip_h = true
			elif direction.x < 0:
				animated_sprite.flip_h = false
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()


func _on_nav_ag_navigation_finished():
	finished = true



func _on_nav_ag_target_reached():
	pass
