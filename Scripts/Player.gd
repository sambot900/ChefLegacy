extends CharacterBody2D

@export var speed = 300
@export var accel = 20

var command_queue = []
var current_command = null
var finished = false

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

func enqueue_command(target_pos: Vector2):
	if command_queue.size() > 0 and command_queue[-1] != target_pos:
		command_queue.append(target_pos)
		print("Command enqueued: ", target_pos)
		print("Current queue: ", command_queue)
	elif command_queue.size() == 0:
		print("Adding: ", target_pos)
		command_queue.append(target_pos)
		print("Current queue: ", command_queue)
	else:
		print("Dupe")

func _on_c_dd_left_pressed():
	print("c_dd_left pressed at global position: ", global_position)
	enqueue_command(Vector2(654, 259))

func _on_c_dd_right_pressed():
	print("c_dd_right pressed at global position: ", global_position)
	enqueue_command(Vector2(728, 241))

func _on_c_ms_left_pressed():
	print("c_ms_left pressed at global position: ", global_position)
	enqueue_command(Vector2(160, -30))

func _on_c_ms_right_pressed():
	print("c_ms_right pressed at global position: ", global_position)
	enqueue_command(Vector2(220, -30))

func _on_c_s_left_pressed():
	print("c_s_left pressed at global position: ", global_position)
	enqueue_command(Vector2(340, -10))

func _on_c_s_right_pressed():
	print("c_s_right pressed at global position: ", global_position)
	enqueue_command(Vector2(420, -10))

func _on_c_ts_1_pressed():
	print("c_ts_1 pressed at global position: ", global_position)
	enqueue_command(Vector2(440, 100))

func _on_c_ts_2_pressed():
	print("c_ts_2 pressed at global position: ", global_position)
	enqueue_command(Vector2(440, 170))

func _on_c_ts_3_pressed():
	print("c_ts_3 pressed at global position: ", global_position)
	enqueue_command(Vector2(440, 250))

func _on_c_f_left_pressed():
	print("c_f_left pressed at global position: ", global_position)
	enqueue_command(Vector2(220, 250))

func _on_c_f_right_pressed():
	print("c_f_right pressed at global position: ", global_position)
	enqueue_command(Vector2(275, 250))

func _on_c_fs_3_pressed():
	print("c_fs_3 pressed at global position: ", global_position)
	enqueue_command(Vector2(100, 250))
	
func _on_c_fs_2_pressed():
	print("c_fs_2 pressed at global position: ", global_position)
	enqueue_command(Vector2(20, 250))
	
func _on_c_fs_1_pressed():
	print("c_fs_1 pressed at global position: ", global_position)
	enqueue_command(Vector2(-75, 250))

func _on_c_t_pressed():
	print("c_t pressed at global position: ", global_position)
	enqueue_command(Vector2(-130, 100))

func _on_c_bob_pressed():
	print("c_bob pressed at global position: ", global_position)
	enqueue_command(Vector2(140, -30))
	
func _on_c_o1_pressed():
	print("c_o1 pressed at global position: ", global_position)
	enqueue_command(Vector2(-80, 30))
	
func _on_c_o2_pressed():
	print("c_o2 pressed at global position: ", global_position)
	enqueue_command(Vector2(-10, -10))
	
func _on_c_o3_pressed():
	print("c_o3 pressed at global position: ", global_position)
	enqueue_command(Vector2(30, -30))
	
func _on_c_o4_pressed():
	print("c_o4 pressed at global position: ", global_position)
	enqueue_command(Vector2(-30, 30))

func _physics_process(delta):

	
	if finished == true and command_queue.size() > 0:
		current_command = command_queue.pop_front()
		agent.target_position = current_command
		finished = false
	elif finished == true and command_queue.size() == 0:
		animated_sprite.play("idle")
	
	if not finished:
		animated_sprite.play("L-walk")
		var direction = (agent.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		
		if direction.x > 0:
				animated_sprite.flip_h = true
		elif direction.x < 0:
			animated_sprite.flip_h = false
		
		move_and_slide()


func _on_nav_ag_navigation_finished():
	finished = true


func _on_nav_ag_target_reached():
	pass
