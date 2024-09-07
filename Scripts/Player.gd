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
var char_facing_left = true

var enabled
var ph_laden
var oh_laden
var previous_player_state = []
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
@onready var anim_torso: AnimatedSprite2D = $avatar/torso
@onready var anim_legs: AnimatedSprite2D = $avatar/legs
@onready var anim_avatar: AnimatedSprite2D = $avatar
@onready var anim_left_arm_idle: Sprite2D = $avatar/arms/left_arm_idle
@onready var anim_right_arm_idle: Sprite2D = $avatar/arms/right_arm_idle
@onready var anim_left_arm_plate: Sprite2D =  $avatar/arms/left_arm_plate
@onready var anim_right_arm_plate: Sprite2D = $avatar/arms/right_arm_plate
@onready var anim_arm_ph: Node2D = $avatar/arms/ph_obj
@onready var anim_arm_oh: Node2D = $avatar/arms/oh_obj
@onready var freezer_fries: Sprite2D = $"../INTERACTABLES/Freezer/FreezerFries"
@onready var freezer_fries_rings: Sprite2D = $"../INTERACTABLES/Freezer/FreezerFries&Rings"


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
		anim_legs.play("idle")
	
# Locomotion & Orientation
	if not finished:
		var direction = (agent.get_next_path_position() - global_position).normalized()
		if direction.x > 0 or direction.x < 0 or direction.y > 0 or direction.y < 0:
			anim_legs.play("L-walk")

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
		anim_torso.z_index = 20
		anim_legs.z_index = 14
	elif global_position.y > 168 and global_position.y < 384:
		anim_torso.z_index = 14
		anim_legs.z_index = 12
	elif global_position.y < 160:
		anim_torso.z_index = 7
		anim_legs.z_index = 7
		
	anim_left_arm_idle.z_index = anim_torso.z_index + 1
	anim_right_arm_idle.z_index = anim_torso.z_index + 1
	anim_left_arm_plate.z_index = anim_torso.z_index + 1
	anim_right_arm_plate.z_index = anim_torso.z_index + 1
	freezer_fries.z_index = anim_legs.z_index + 1
	freezer_fries_rings.z_index = anim_legs.z_index + 1
	
		

func orientation_edge_case():
# Reset edge case detection for each command
	orientation_edge_case_r = false
	orientation_edge_case_l = false

	# ---------------------------------------------------------------------------------------------------------
	# R2
	# If you are in general right, and your command is far top-right
	# (global_position.x > 610) and (current_command.x < 625)
	# ---------------------------------------------------------------------------------------------------------
	if current_command.y < 38:
		if (global_position.x > 598) and (current_command.x < 625) and (orientation_edge_case_r == false):
			orientation_edge_case_r = false
			#print("edge case R2 VOID")
	# ---------------------------------------------------------------------------------------------------------
	# R3
	# You are in general right... your command is anywhere under the "top-right area" defined in R2 (above)
	# (global_position.x > 620) and (current_command.x > 652 and current_command.y > 37)
	# ---------------------------------------------------------------------------------------------------------
	elif current_command.y < 122:
		if (global_position.x > 598) and (current_command.x > 624 and current_command.y > 37) and (orientation_edge_case_r == false):
			orientation_edge_case_r = true
			#print("edge case R3")
	# ---------------------------------------------------------------------------------------------------------
	# R4
	# If you're command is below the topping station
	# You are in general right and command is far right, and your command is below box o buns.
	elif current_command.y > 121:
		if (global_position.x > 620) and (current_command.x > 624 and current_command.y > 80) and (orientation_edge_case_r == false):
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
	if orientation_lock == false: # right
		if direction.x > 0:
			anim_torso.flip_h = true
			anim_legs.flip_h = true
			anim_legs.offset.x = 39
			char_facing_left = false
			
			
		elif direction.x < 0: # left
			anim_torso.flip_h = false
			anim_legs.flip_h = false
			anim_legs.offset.x = 29
			char_facing_left = true
			
					
	else:
		if orientation_edge_case_l:
			if anim_legs.flip_h == true: # right
				anim_torso.flip_h = false
				anim_legs.flip_h = false
				anim_legs.offset.x = 39
		elif orientation_edge_case_r:
			if anim_legs.flip_h == false: # left
				anim_torso.flip_h = true
				anim_legs.flip_h = true
				anim_legs.offset.x = 39

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

func _on__burgers_obj_changed(cmd, obj_array, action):
	if cmd == "player":
		match action:
			"ph_up":
				update_p_sprites(anim_arm_ph, obj_array, Vector2(-46,-55))
			"ph_down":
				update_p_sprites(anim_arm_ph, obj_array, Vector2(-46,-55))
			"ph_swap":
				update_p_sprites(anim_arm_ph, obj_array, Vector2(-46,-55))
			"oh_up":
				update_p_sprites(anim_arm_oh, obj_array, Vector2(74, -51))
			"oh_down":
				update_p_sprites(anim_arm_oh, obj_array, Vector2(74, -51))
			"oh_swap":
				update_p_sprites(anim_arm_oh, obj_array, Vector2(74, -51))
			
# stored objects
func update_p_sprites(target_node: Node, item_texture_paths: Array, start_position: Vector2):
	print("update_i_sprites: ", target_node, item_texture_paths)
	# Remove all existing Sprite2D children from target_node
	for child in target_node.get_children():
		if child is Sprite2D:
			child.queue_free()

	# Return early if the array is empty
	if item_texture_paths.size() == 0:
		return

	var y_offset = 0  # Initialize y-offset for stacking
	var base_z_index = target_node.z_index  # Set a base z_index

	# Iterate through texture paths and create new sprites
	for texture_path in item_texture_paths:
		var item_sprite = Sprite2D.new()
		item_sprite.texture = load(texture_path)
		
		# Set scale
		item_sprite.scale = Vector2(0.5, 0.5)

		# Set z_index of each array obj
		item_sprite.z_index = 100
		base_z_index += 1
		
		item_sprite.position = start_position + Vector2(0, y_offset)  # Set position with offset
		target_node.add_child(item_sprite)  # Add sprite to parent

		# Update y-offset to stack the next sprite on top of the previous one
		y_offset -= item_sprite.texture.get_size().y / 2 * item_sprite.scale.y  # Adjust scaled height

func _avatar_unladen():
	anim_left_arm_idle.visible = true
	anim_right_arm_idle.visible = true
	anim_left_arm_plate.visible = false
	anim_right_arm_plate.visible = false
	
func _avatar_ph():
	anim_left_arm_idle.visible = false
	anim_right_arm_idle.visible = true
	anim_left_arm_plate.visible = true
	anim_right_arm_plate.visible = false
	
func _avatar_oh():
	anim_left_arm_idle.visible = true
	anim_right_arm_idle.visible = false
	anim_left_arm_plate.visible = false
	anim_right_arm_plate.visible = true
	
func _avatar_both():
	anim_left_arm_idle.visible = false
	anim_right_arm_idle.visible = false
	anim_left_arm_plate.visible = true
	anim_right_arm_plate.visible = true

func _on__burgers_state_changed(cmd, state_array):
	if cmd == "ms_left":
		_hand_sounds()
	if (previous_player_state.size() == 3) and (state_array.size() == 3) and (cmd == "player"):
		if (state_array[0] + state_array[1] + state_array[2]) != (previous_player_state[0] + previous_player_state[1] + previous_player_state[2]):
			_hand_sounds()
	if state_array and (cmd == "player"):
		if state_array == [1,0,0]:
			_avatar_unladen()
		elif state_array == [1,1,0]:
			_avatar_ph()
		elif state_array == [1,0,1]:
			_avatar_oh()
		elif state_array == [1,1,1]:
			_avatar_both()
		elif state_array == [0,0,0]:
			_avatar_unladen()
		elif state_array == [0,1,0]:
			_avatar_ph()
		elif state_array == [0,0,1]:
			_avatar_oh()
		elif state_array == [0,1,1]:
			_avatar_both()
		previous_player_state = state_array

func _hand_sounds():
	var audio_player = $hand
	var sound = load("res://Sounds/swing.wav")
	audio_player.stream = sound
	audio_player.play()
