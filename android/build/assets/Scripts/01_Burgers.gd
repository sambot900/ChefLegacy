extends Node2D

######################################################
# 	Root (01_Burgers)
######################################################

#region Signal Declarations
signal dd_left
signal dd_right
signal ms_left
signal ms_right
signal fs_1
signal fs_2
signal s_left
signal s_right
signal ts_1
signal ts_2
signal ts_3
signal f_1
signal f_2
signal t_1
signal t_2
signal bob
signal o_1
signal o_2
signal o_3
signal o_4

signal go_here
signal state_changed(cmd, state_array: Array)
signal obj_changed(cmd, state_array: Array)
#endregion

#region Dictionary Init: coordinate_key
var area_2d_cmd_key = {}

var y_ts = 130
var y_ts2 = 210
var coordinate_key = {
	"dd_left": [Vector2(307, 423), Vector2(337, 423), Vector2(367, 423)],
	"dd_right": [Vector2(379, 423), Vector2(409, 423), Vector2(439, 423)],
	"ms_left": [Vector2(524, 14), Vector2(554, 14), Vector2(584, 14)],
	"ms_right": [Vector2(610, 14)],
	"fs_1": [Vector2(625, 265), Vector2(625, 295), Vector2(625, 325)],
	"fs_2": [Vector2(625, 329), Vector2(625, 359), Vector2(625, 389)],
	"s_left": [Vector2(318, -9), Vector2(348, -9), Vector2(378, -9)],
	"s_right": [Vector2(444, -9), Vector2(474, -9), Vector2(504, -9)],
	"ts_1": [Vector2(320, y_ts), Vector2(350, y_ts), Vector2(380, y_ts), Vector2(238, y_ts), Vector2(238, 140), Vector2(238, 170), Vector2(320, y_ts2), Vector2(350, y_ts2), Vector2(380, y_ts2)],
	"ts_2": [Vector2(407, y_ts), Vector2(437, y_ts), Vector2(467, y_ts), Vector2(407, y_ts2), Vector2(437, y_ts2), Vector2(467, y_ts2)],
	"ts_3": [Vector2(495, y_ts), Vector2(525, y_ts), Vector2(555, y_ts), Vector2(612, 108), Vector2(612, 138), Vector2(612, 144), Vector2(495, y_ts2), Vector2(525, y_ts2), Vector2(555, y_ts2)],
	"trash": [Vector2(245, y_ts), Vector2(245, y_ts2)],
	"f_1": [Vector2(625, 133), Vector2(625, 148), Vector2(625, 163)],
	"f_2": [Vector2(625, 185), Vector2(625, 200), Vector2(625, 215)],
	"t_1": [Vector2(625, 428), Vector2(625, 453), Vector2(625, 478)],
	"t_2": [Vector2(625, 494), Vector2(625, 519), Vector2(625, 544)],
	"bob": [Vector2(626, 46), Vector2(626, 71)],
	"o_1": [Vector2(292, 572)],
	"o_2": [Vector2(424, 572)],
	"o_3": [Vector2(558, 572)],
	"o_4": [Vector2(686, 572)]
}
#endregion

#region Dictionary Init: cmd_count
var cmd_count = {
	"dd_left": 0, "dd_right": 0, "ms_left": 0, "ms_right": 0,
	"fs_1": 0, "fs_2": 0, "s_left": 0, "s_right": 0,
	"ts_1": 0, "ts_2": 0, "ts_3": 0, "trash": 0, "f_1": 0, "f_2": 0,
	"t_1": 0, "t_2": 0, "bob": 0, "o_1": 0, "o_2": 0, "o_3": 0, "o_4": 0
}

var cmd_count_max = {
	"dd_left": 2, "dd_right": 2, "ms_left": 2, "ms_right": 2,
	"fs_1": 2, "fs_2": 2, "s_left": 2, "s_right": 2,
	"ts_1": 2, "ts_2": 2, "ts_3": 2, "trash": 1, "f_1": 2, "f_2": 2,
	"t_1": 2, "t_2": 2, "bob": 2, "o_1": 1, "o_2": 1, "o_3": 1, "o_4": 1
}
#endregion

#region Declarations

# Constants
const BASE_WIDTH = 648
const BASE_HEIGHT = 1152
const MAX_WIDTH = 666

# Variables
var player_state = []
var i_node = {}
var interactable_state = {}
var interactables_accepts = {}
var stored_objects = {}
var previous_command
var order_1 = []
var order_2 = []
var order_3 = []
var order_4 = []
var cheese
var previous_sprite


var obj_raw_patty_1 = "res://Sprites/Levels/01_Burgers/Food/raw_patty_1.png"
var obj_raw_patty_2 = "res://Sprites/Levels/01_Burgers/Food/raw_patty_2.png"
var obj_cooked_patty_1 = "res://Sprites/Levels/01_Burgers/Food/cooked_patty_1.png"
var obj_cooked_patty_2 = "res://Sprites/Levels/01_Burgers/Food/cooked_patty_2.png"
var obj_burnt_patty_1 = "res://Sprites/Levels/01_Burgers/Food/burnt_patty_1.png"
var obj_burnt_patty_2 = "res://Sprites/Levels/01_Burgers/Food/burnt_patty_2.png"
var obj_top_bun = "res://Sprites/Levels/01_Burgers/Food/top_bun.png"
var obj_bot_bun = "res://Sprites/Levels/01_Burgers/Food/bot_bun.png"
var obj_cheese_1 = "res://Sprites/Levels/01_Burgers/Food/cheese_slice.png"
var obj_bacon_1 = "res://Sprites/Levels/01_Burgers/Food/bacon_slice.png"
var obj_lettuce_1 = "res://Sprites/Levels/01_Burgers/Food/lettuce_slice.png"
var obj_frozen_fries_1 = "res://Sprites/Levels/01_Burgers/Food/frozen_fries.png"
var obj_cooked_fries_1 = "res://Sprites/Levels/01_Burgers/Food/cooked_fries.png"
var obj_cooked_fries_pile_1 = "res://Sprites/Levels/01_Burgers/Food/cooked_fries_pile.png"
var obj_burnt_fries_1 = "res://Sprites/Levels/01_Burgers/Food/burnt_fries.png"
var obj_frozen_fries_2 = ""
var obj_frozen_rings_1 = "res://Sprites/Levels/01_Burgers/Food/frozen_rings.png"
var obj_cooked_rings_1 = "res://Sprites/Levels/01_Burgers/Food/cooked_rings.png"
var obj_cooked_rings_pile_1 = "res://Sprites/Levels/01_Burgers/Food/cooked_rings_pile.png"
var obj_burnt_rings_1 = "res://Sprites/Levels/01_Burgers/Food/burnt_rings.png"
var obj_frozen_rings_2 = ""
var obj_orange_drink = "res://Sprites/Levels/01_Burgers/Food/oj_full.png"
var obj_cola_drink = "res://Sprites/Levels/01_Burgers/Food/cola_full.png"
var obj_empty_drink = "res://Sprites/Levels/01_Burgers/Food/cup_empty.png"
#endregion


#region onready Declarations
@onready var background = $"MISCELLANEOUS/Main BG"
@onready var timer_manager = $Timer
@onready var cook_avatar = $Player
@onready var cmds_node = $CMDs
@onready var round_camera = $MISCELLANEOUS/Camera2D
@onready var camera_animation_player = $CameraAnimationPlayer
@onready var dd = $INTERACTABLES/DrinkDispenser
@onready var freezer = $INTERACTABLES/Freezer
@onready var player = $Player


#endregion

func _ready():
	adjust_background()
	get_viewport().connect("size_changed", Callable(self, "_on_size_changed"))
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))
	
	interactables_accepts["dd_left"] = []
	interactables_accepts["dd_right"] = []
	interactables_accepts["ms_left"] = []
	interactables_accepts["ms_right"] = []
	interactables_accepts["s_left"] = [obj_raw_patty_1, obj_raw_patty_2]
	interactables_accepts["s_right"] = [obj_raw_patty_1, obj_raw_patty_2]
	
	interactables_accepts["ts_1"] = [
	[obj_cooked_patty_1],
	[obj_cooked_patty_1, obj_bacon_1, obj_lettuce_1],
	[obj_cooked_patty_1, obj_lettuce_1],
	[obj_cooked_patty_1, obj_bacon_1],
	
	[obj_cooked_patty_2],
	[obj_cooked_patty_2, obj_bacon_1, obj_lettuce_1],
	[obj_cooked_patty_2, obj_lettuce_1],
	[obj_cooked_patty_2, obj_bacon_1],
	]
	
	interactables_accepts["ts_2"] = [
	[obj_cooked_patty_1],
	[obj_cooked_patty_1, obj_cheese_1, obj_lettuce_1],
	[obj_cooked_patty_1, obj_lettuce_1],
	[obj_cooked_patty_1, obj_cheese_1],
	
	[obj_cooked_patty_2],
	[obj_cooked_patty_2, obj_cheese_1, obj_lettuce_1],
	[obj_cooked_patty_2, obj_lettuce_1],
	[obj_cooked_patty_2, obj_cheese_1],
	]
	interactables_accepts["ts_3"] = [
	[obj_cooked_patty_1],
	[obj_cooked_patty_1, obj_cheese_1, obj_bacon_1],
	[obj_cooked_patty_1, obj_bacon_1],
	[obj_cooked_patty_1, obj_cheese_1],
	
	[obj_cooked_patty_2],
	[obj_cooked_patty_2, obj_cheese_1, obj_bacon_1],
	[obj_cooked_patty_2, obj_bacon_1],
	[obj_cooked_patty_2, obj_cheese_1],
	]
	
	interactables_accepts["f_1"] = [obj_frozen_fries_1, obj_frozen_fries_2, obj_frozen_rings_1, obj_frozen_rings_2]
	interactables_accepts["f_2"] = [obj_frozen_fries_1, obj_frozen_fries_2, obj_frozen_rings_1, obj_frozen_rings_2]
	interactables_accepts["fs_1"] = []
	interactables_accepts["fs_2"] = []
	interactables_accepts["t_1"] = "any"
	interactables_accepts["t_2"] = "any"
	
	interactables_accepts["bob"] = [
	[obj_cooked_patty_1],  # Just the patty
	[obj_cooked_patty_1, obj_cheese_1],  # Patty with cheese
	[obj_cooked_patty_1, obj_bacon_1],  # Patty with bacon
	[obj_cooked_patty_1, obj_lettuce_1],  # Patty with lettuce
	[obj_cooked_patty_1, obj_cheese_1, obj_bacon_1],  # Patty with cheese and bacon
	[obj_cooked_patty_1, obj_cheese_1, obj_lettuce_1],  # Patty with cheese and lettuce
	[obj_cooked_patty_1, obj_bacon_1, obj_lettuce_1],  # Patty with bacon and lettuce
	[obj_cooked_patty_1, obj_cheese_1, obj_bacon_1, obj_lettuce_1],  # Patty with cheese, bacon, and lettuce

	[obj_cooked_patty_2],  # Second patty
	[obj_cooked_patty_2, obj_cheese_1],  # Patty 2 with cheese
	[obj_cooked_patty_2, obj_bacon_1],  # Patty 2 with bacon
	[obj_cooked_patty_2, obj_lettuce_1],  # Patty 2 with lettuce
	[obj_cooked_patty_2, obj_cheese_1, obj_bacon_1],  # Patty 2 with cheese and bacon
	[obj_cooked_patty_2, obj_cheese_1, obj_lettuce_1],  # Patty 2 with cheese and lettuce
	[obj_cooked_patty_2, obj_bacon_1, obj_lettuce_1],  # Patty 2 with bacon and lettuce
	[obj_cooked_patty_2, obj_cheese_1, obj_bacon_1, obj_lettuce_1]  # Patty 2 with cheese, bacon, and lettuce
	]
	
	interactables_accepts["o_1"] = order_1
	interactables_accepts["o_2"] = order_2
	interactables_accepts["o_3"] = order_3
	interactables_accepts["o_4"] = order_4
	
	i_node["dd_left"] = $INTERACTABLES/DrinkDispenser/dd_left
	i_node["dd_right"] = $INTERACTABLES/DrinkDispenser/dd_right
	i_node["ms_left"] = $INTERACTABLES/MeatSource1
	i_node["ms_right"] = $INTERACTABLES/MeatSource2
	i_node["s_left"] = $INTERACTABLES/Stove/s_left
	i_node["s_right"] = $INTERACTABLES/Stove/s_right
	i_node["ts_1"] = $"INTERACTABLES/TOPPING STATIONS/topping_station_1"
	i_node["ts_2"] = $"INTERACTABLES/TOPPING STATIONS/topping_station_2"
	i_node["ts_3"] = $"INTERACTABLES/TOPPING STATIONS/topping_station_3"
	i_node["f_1"] = $INTERACTABLES/Fryer/f_1
	i_node["f_2"] = $INTERACTABLES/Fryer/f_2
	i_node["fs_1"] = $INTERACTABLES/Freezer/fs_1
	i_node["fs_2"] = $INTERACTABLES/Freezer/fs_2
	i_node["t_1"] = $INTERACTABLES/HelperTray1
	i_node["t_2"] = $INTERACTABLES/HelperTray2
	i_node["bob"] = $INTERACTABLES/BOB
	i_node["o_1"] = $INTERACTABLES/o_1
	i_node["o_2"] = $INTERACTABLES/o_2
	i_node["o_3"] = $INTERACTABLES/o_3
	i_node["o_4"] = $INTERACTABLES/o_4
	
	stored_objects["dd_left"] = []
	stored_objects["dd_right"] = []
	stored_objects["ms_left"] = [obj_raw_patty_1]
	stored_objects["ms_right"] = [obj_raw_patty_2]
	stored_objects["s_left"] = []
	stored_objects["s_right"] = []
	stored_objects["ts_1"] = []
	stored_objects["ts_2"] = []
	stored_objects["ts_3"] = []
	stored_objects["f_1"] = []
	stored_objects["f_2"] = []
	stored_objects["fs_1"] = []
	stored_objects["fs_2"] = []
	stored_objects["t_1"] = []
	stored_objects["t_2"] = []
	stored_objects["bob"] = [obj_bot_bun, obj_top_bun]
	stored_objects["o_1"] = []
	stored_objects["o_2"] = []
	stored_objects["o_3"] = []
	stored_objects["o_4"] = []
	
	stored_objects["player_ph"] = []
	stored_objects["player_oh"] = []

func _input(_event):
	pass

func _on_size_changed():
	adjust_background()

func start_camera_pan():
	if round_camera and camera_animation_player:
		camera_animation_player.play("PanCamera")
	else:
		print("Camera and AnimationPlayer not found")

func adjust_background():
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	
	var base_width = 648
	var background_width = 678  # Width of your background image
	var background_height = 1100  # Width of your background image
	
	# Horizontal Scaling
	if screen_width >= background_width:
		$MISCELLANEOUS/Camera2D.offset.x = (-(screen_width - background_width)/2)
		print("offset: ", $MISCELLANEOUS/Camera2D.offset.x)
	elif screen_height >= background_height:
		pass
	else:
		print("scaling-horiz exception")
		
	

	

func s_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap", "timer"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false

	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("decision state before: ",state)
						##########################################################
						# player  | player | player || object    | object | object #
	if state:			# enabled | PH     | OH     || cooked    | active | laden  #
			###########################################################################
		# p:both i:idle
		if state ==	 	 [1,       1,       1,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_ph"][0] in interactables_accepts["s_left"]:
					print("p:both i:idle -> i:active laden")
					p_state = [1,0,1]
					i_state = [0,1,1]
					action = "ph_down"
				elif stored_objects["player_oh"][0] in interactables_accepts["s_left"]:
					print("p:both i:idle -> i:active laden")
					p_state = [1,1,0]
					i_state = [0,1,1]
					action = "oh_down"
			
		# p:oh i:idle
		elif state ==	 [1,       0,       1,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_oh"][0] in interactables_accepts["s_left"]:
					print("p:oh i:idle -> i:active laden")
					p_state = [1,0,0]
					i_state = [0,1,1]
					action = "oh_down"
	
		# p:ph i:idle
		elif state == 	 [1,       1,       0,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_ph"][0] in interactables_accepts["s_left"]:
					print("p:ph i:idle -> i:active laden")
					p_state = [1,0,0]
					i_state = [0,1,1]
					action = "ph_down"
			
		# p:free i:idle
		elif state == 	 [1,       0,       0,         0,        0,       0]:
			if targ_reached:
				print("p:free i:idle -> same")
				p_skip = true
				i_skip = true
			###########################################################################
		
		# p:both i:active and laden
		elif state == 	 [1,       1,       1,         0,        1,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["s_left"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					print("p:both i:active and laden -> ph_swap")
					action = "ph_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["s_left"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					print("p:both i:active and laden -> oh_swap")
					action = "oh_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				else:
					print("p:both i:active and laden -> same")
					p_skip = true
					i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:oh i:active and laden
		elif state == 	 [1,       0,       1,         0,        1,       1]:
			if targ_reached:
				print("p:oh i:active and laden -> p:both i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:ph i:active and laden
		elif state == 	 [1,       1,       0,         0,        1,       1]:
			if targ_reached:
				print("p:ph i:active and laden -> p:both i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "oh_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:free i:active and laden
		elif state == 	 [1,       0,       0,         0,        1,       1]:
			if targ_reached:
				print("p:free i:active and laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:full i:cooked
		elif state == 	 [1,       1,       1,         1,        1,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["s_left"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					print("p:both i:cooked and laden -> ph_swap")
					action = "ph_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["s_left"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					print("p:both i:cooked and laden -> oh_swap")
					action = "oh_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				else:
					print("p:full i:cooked -> same")
					p_skip = true
					i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
				print("i:cooked -> i:burnt")
			
		# p:oh i:cooked
		elif state == 	 [1,       0,       1,         1,        1,       1]:
			if targ_reached:
				print("p:oh i:cooked -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
				print("i:cooked -> i:burnt")
			
		# p:ph i:cooked
		elif state == 	 [1,       1,       0,         1,        1,       1]:
			if targ_reached:
				print("p:ph i:cooked -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
				print("i:cooked -> i:burnt")
				
		# p:free i:cooked
		elif state == 	 [1,       0,       0,         1,        1,       1]:
			if targ_reached:
				print("p:free i:laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
				print("i:cooked -> i:burnt")
			
			
		# p:full i:burnt
		elif state ==	 [1,       1,       1,         0,        0,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["s_left"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					print("p:both i:cooked and laden -> ph_swap")
					action = "ph_swap"
					p_state = [1,1,1]
					i_state = [0,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["s_left"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					print("p:both i:cooked and laden -> oh_swap")
					action = "oh_swap"
					p_state = [1,1,1]
					i_state = [0,1,1]
				else:
					print("p:full i:burnt -> same")
					p_skip = true
					i_skip = true
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
			
		# p:oh i:burnt
		elif state ==	 [1,       0,       1,         0,        0,       1]:
			if targ_reached:
				print("p:oh i:burnt -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "ph_up"
				
		# p:ph i:burnt
		elif state ==	 [1,       1,       0,         0,        0,       1]:
			if targ_reached:
				print("p:ph i:burnt -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "oh_up"
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
				
		# p:free i:burnt
		elif state ==	 [1,       0,       0,         0,        0,       1]:
			if targ_reached:
				print("p:free i:burnt -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
				
		###########################################################################		
		else:																 # edge cases
			print("s decision tree error case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	print("decision state after: ",player_state + interactable_state[cname])
	return action

func dd_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap", "activate"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("decision state before: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       0]: # idle
			if targ_reached:
				timer_manager.start_timer(cname)
				print("p:full i:idle -> i:active")
				action = "activate"
				p_state = [1,1,1]
				i_state = [1,1,0]
			
		elif state ==	 [1,       0,       1,         1,        0,       0]:
			if targ_reached:
				timer_manager.start_timer(cname)
				print("p:oh i:idle -> i:active")
				action = "activate"
				p_state = [1,0,1]
				i_state = [1,1,0]
			
		elif state == 	 [1,       1,       0,         1,        0,       0]:
			if targ_reached:
				timer_manager.start_timer(cname)
				print("p:ph i:idle -> i:active")
				action = "activate"
				p_state = [1,1,0]
				i_state = [1,1,0]
		elif state == 	 [1,       0,       0,         1,        0,       0]:
			if targ_reached:
				timer_manager.start_timer(cname)
				print("p:empty i:idle -> i:active")
				action = "activate"
				p_state = [1,0,0]
				i_state = [1,1,0]
			###########################################################################
		elif state == 	 [1,       1,       1,         1,        1,       0]: # active
			if targ_reached:
				print("p:full i:busy -> same")
				p_skip = true
				i_skip = true
			
		elif state == 	 [1,       0,       1,         1,        1,       0]:
			if targ_reached:
				print("p:oh i:busy -> same")
				p_skip = true
				i_skip = true
			
		elif state == 	 [1,       1,       0,         1,        1,       0]:
			if targ_reached:
				print("p:ph i:busy -> same")
				p_skip = true
				i_skip = true
			
		elif state == 	 [1,       0,       0,         1,        1,       0]:
			if targ_reached:
				print("p:empty i:busy -> same")
				p_skip = true
				i_skip = true
			
			###########################################################################				
		elif state == 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden -> same")
				p_skip = true
				i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
		elif state == 	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				print("p:oh i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
			
		elif state ==	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				print("p:ph i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = "oh_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
			
		elif state ==	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				print("p:empty i:laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [1,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	print("decision state after: ",player_state + interactable_state[cname])
	return action
	
func ms_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("b: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden-> same")
				p_skip = true
				i_skip = true
			
		elif state ==	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				print("p:oh i:laden -> p:full")
				p_state = [1,1,1]
				i_skip = true
				action = "ph_up"
			
		elif state == 	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				print("p:ph i:laden -> p:full")
				p_state = [1,1,1]
				i_skip = true
				action = "oh_up"
		elif state == 	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				print("p:empty i:laden -> p:ph")
				p_state = [1,1,0]
				i_skip = true
				action = "ph_up"
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	return action	
		
func f_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap", "timer"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false

	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("decision state before: ",state)
						##########################################################
						# player  | player | player || object    | object | object #
	if state:			# enabled | PH     | OH     || cooked    | active | laden  #
			###########################################################################
		# p:both i:idle
		if state ==	 	 [1,       1,       1,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_ph"][0] in interactables_accepts["f_1"]:
					p_state = [1,0,1]
					i_state = [0,1,1]
					action = "ph_down"
				elif stored_objects["player_oh"][0] in interactables_accepts["f_1"]:
					p_state = [1,1,0]
					i_state = [0,1,1]
					action = "oh_down"
			
		# p:oh i:idle
		elif state ==	 [1,       0,       1,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_oh"][0] in interactables_accepts["f_1"]:
					p_state = [1,0,0]
					i_state = [0,1,1]
					action = "oh_down"
	
		# p:ph i:idle
		elif state == 	 [1,       1,       0,         0,        0,       0]:
			if targ_reached:
				if stored_objects["player_ph"][0] in interactables_accepts["f_1"]:
					p_state = [1,0,0]
					i_state = [0,1,1]
					action = "ph_down"
			
		# p:free i:idle
		elif state == 	 [1,       0,       0,         0,        0,       0]:
			if targ_reached:
				p_skip = true
				i_skip = true
			###########################################################################
		
		# p:both i:active and laden
		elif state == 	 [1,       1,       1,         0,        1,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["f_1"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					action = "ph_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["f_1"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					action = "oh_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				else:
					p_skip = true
					i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:oh i:active and laden
		elif state == 	 [1,       0,       1,         0,        1,       1]:
			if targ_reached:
				print("p:oh i:active and laden -> p:both i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:ph i:active and laden
		elif state == 	 [1,       1,       0,         0,        1,       1]:
			if targ_reached:
				print("p:ph i:active and laden -> p:both i:idle")
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "oh_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:free i:active and laden
		elif state == 	 [1,       0,       0,         0,        1,       1]:
			if targ_reached:
				print("p:free i:active and laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,1,1]
			
		# p:full i:cooked
		elif state == 	 [1,       1,       1,         1,        1,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["f_1"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					action = "ph_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["f_1"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					action = "oh_swap"
					p_state = [1,0,0]
					i_state = [1,1,1]
				else:
					p_skip = true
					i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
			
		# p:oh i:cooked
		elif state == 	 [1,       0,       1,         1,        1,       1]:
			if targ_reached:
				p_state = [1,1,1]
				i_state = [0,0,0]
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
			
		# p:ph i:cooked
		elif state == 	 [1,       1,       0,         1,        1,       1]:
			if targ_reached:
				p_state = [1,1,1]
				i_state = [0,0,0]
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
				
		# p:free i:cooked
		elif state == 	 [1,       0,       0,         1,        1,       1]:
			if targ_reached:
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [0,0,1]
			
			
		# p:full i:burnt
		elif state ==	 [1,       1,       1,         0,        0,       1]:
			if targ_reached:
				if (stored_objects["player_ph"][0] in interactables_accepts["f_1"]) and stored_objects["player_ph"][0] != stored_objects[cname][0]:
					action = "ph_swap"
					p_state = [1,1,1]
					i_state = [0,1,1]
				elif (stored_objects["player_oh"][0] in interactables_accepts["f_1"]) and stored_objects["player_oh"][0] != stored_objects[cname][0]:
					action = "oh_swap"
					p_state = [1,1,1]
					i_state = [0,1,1]
				else:
					p_skip = true
					i_skip = true
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
			
		# p:oh i:burnt
		elif state ==	 [1,       0,       1,         0,        0,       1]:
			if targ_reached:
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "ph_up"
				
		# p:ph i:burnt
		elif state ==	 [1,       1,       0,         0,        0,       1]:
			if targ_reached:
				p_state = [1,1,1]
				i_state = [0,0,0]
				action = "oh_up"
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
				
		# p:free i:burnt
		elif state ==	 [1,       0,       0,         0,        0,       1]:
			if targ_reached:
				p_state = [1,1,0]
				i_state = [0,0,0]
				action = "ph_up"
			else:
				action = "timer2"
				p_skip = true
				i_skip = true
				
		###########################################################################		
		else:																 # edge cases
			print("s decision tree error case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	print("decision state after: ",player_state + interactable_state[cname])
	return action

func fs_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("b: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden-> same")
				p_skip = true
				i_skip = true
			
		elif state ==	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				print("p:oh i:laden -> p:full")
				p_state = [1,1,1]
				i_skip = true
				action = "ph_up"
			
		elif state == 	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				print("p:ph i:laden -> p:full")
				p_state = [1,1,1]
				i_skip = true
				action = "oh_up"
		elif state == 	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				print("p:empty i:laden -> p:ph")
				p_state = [1,1,0]
				i_skip = true
				action = "ph_up"
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	return action	

func t_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("b: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				action = "ph_swap"
				p_state = [1,1,1]
				i_state = [1,0,1]
			
		elif state ==	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				action = "ph_up"
				p_state = [1,1,1]
				i_state = [1,0,0]
			
		elif state == 	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				action = "oh_up"
				p_state = [1,1,1]
				i_state = [1,0,0]
				
		elif state == 	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				action = "ph_up"
				p_state = [1,1,0]
				i_state = [1,0,0]
		###########################################################################		
		elif state ==	 	 [1,       1,       1,         1,        0,       0]: # unladen
			if targ_reached:
				action = "ph_down"
				p_state = [1,0,1]
				i_state = [1,0,1]
			
		elif state ==	 [1,       0,       1,         1,        0,       0]:
			if targ_reached:
				action = "oh_down"
				p_state = [1,0,0]
				i_state = [1,0,1]
			
		elif state == 	 [1,       1,       0,         1,        0,       0]:
			if targ_reached:
				action = "ph_down"
				p_state = [1,0,0]
				i_state = [1,0,1]
				
		elif state == 	 [1,       0,       0,         1,        0,       0]:
			if targ_reached:
				action = "ph_up"
				p_skip = true
				i_skip = true
		
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	return action	

func ts_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap", "activate"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("decision state before: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       0]: # idle
			if targ_reached:
				if stored_objects["player_ph"] in interactables_accepts[cname]:
					timer_manager.start_timer(cname)
					print("p:full i:idle -> i:active")
					action = "ph_down"
					p_state = [1,0,1]
					i_state = [1,1,0]
				elif stored_objects["player_oh"] in interactables_accepts[cname]:
					timer_manager.start_timer(cname)
					print("p:full i:idle -> i:active")
					action = "oh_down"
					p_state = [1,1,0]
					i_state = [1,1,0]
			
		elif state ==	 [1,       0,       1,         1,        0,       0]:
			if targ_reached:
				if stored_objects["player_oh"] in interactables_accepts[cname]:
					timer_manager.start_timer(cname)
					print("p:full i:idle -> i:active")
					action = "oh_down"
					p_state = [1,0,0]
					i_state = [1,1,0]
			
		elif state == 	 [1,       1,       0,         1,        0,       0]:
			if targ_reached:
				if stored_objects["player_ph"] in interactables_accepts[cname]:
					timer_manager.start_timer(cname)
					action = "ph_down"
					p_state = [1,0,0]
					i_state = [1,1,0]
					
		elif state == 	 [1,       0,       0,         1,        0,       0]:
			if targ_reached:
				p_skip = true
				i_skip = true
				
			###########################################################################
		elif state == 	 [1,       1,       1,         1,        1,       0]: # active
			if targ_reached:
				print("p:full i:busy -> same")
				p_skip = true
				i_skip = true
				
			
		elif state == 	 [1,       0,       1,         1,        1,       0]:
			if targ_reached:
				print("p:oh i:busy -> same")
				p_skip = true
				i_skip = true
			
		elif state == 	 [1,       1,       0,         1,        1,       0]:
			if targ_reached:
				print("p:ph i:busy -> same")
				p_skip = true
				i_skip = true
			
		elif state == 	 [1,       0,       0,         1,        1,       0]:
			if targ_reached:
				print("p:empty i:busy -> same")
				p_skip = true
				i_skip = true
			
			###########################################################################				
		elif state == 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden -> same")
				p_skip = true
				i_skip = true
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
		elif state == 	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				print("p:oh i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
			
		elif state ==	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				print("p:ph i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = "oh_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
			
		elif state ==	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				print("p:empty i:laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [1,0,0]
				action = "ph_up"
			else:
				action = "timer"
				p_skip = true
				i_state = [1,0,1]
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	print("decision state after: ",player_state + interactable_state[cname])
	return action

func bob_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("b: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden-> same")
				if (stored_objects["player_ph"] in interactables_accepts["bob"]):
					action = "ph_up"
					p_state = [1,1,1]
					i_skip = true
				elif (stored_objects["player_oh"] in interactables_accepts["bob"]):
					action = "oh_up"
					p_state = [1,1,1]
					i_skip = true
				else:
					p_skip = true
					i_skip = true
			
		elif state ==	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				if (stored_objects["player_oh"] in interactables_accepts["bob"]):
					action = "oh_up"
					p_state = [1,0,1]
					i_skip = true
				else:
					p_skip = true
					i_skip = true
			
		elif state == 	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				if (stored_objects["player_ph"] in interactables_accepts["bob"]):
					action = "ph_up"
					p_state = [1,1,0]
					i_skip = true
				else:
					print(stored_objects["player_ph"]," not in ", interactables_accepts["bob"])
					p_skip = true
					i_skip = true
				
				
		elif state == 	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				p_skip = true
				i_skip = true
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
	
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	return action	

func trash_state_decision(cname, targ_reached):
	var action = "none" # "none", "ph_up", "ph_down", "ph_swap", "oh_up", "oh_down", "oh_swap"
	var p_state = player_state
	var i_state = interactable_state[cname]
	var state = p_state+i_state
	var p_skip = false
	var i_skip = false
	print("-----------------------------------------")
	print("COMMAND: ",cname)
	print("b: ",state)
						##########################################################
						# player  | player | player || object  | object | object #
	if state:			# enabled | PH     | OH     || enabled | active | laden  #
			###########################################################################
		if state ==	 	 [1,       1,       1,         1,        0,       0]: # laden
			if targ_reached:
				print("p:full i:laden-> same")
				action = "ph_down"
				p_state = [1,0,1]
				i_skip = true
			
		elif state ==	 [1,       0,       1,         1,        0,       0]:
			if targ_reached:
				print("p:full i:laden-> same")
				action = "oh_down"
				p_state = [1,0,0]
				i_skip = true
			
		elif state == 	 [1,       1,       0,         1,        0,       0]:
			if targ_reached:
				action = "ph_down"
				p_state = [1,0,0]
				i_skip = true
				
				
		elif state == 	 [1,       0,       0,         1,        0,       0]:
			if targ_reached:
				p_skip = true
				i_skip = true
		###########################################################################		
		else:																 # edge cases
			print("decision tree edge case")
			
	if (p_skip == false):
		player_state = p_state
	if (i_skip == false):
		interactable_state[cname] = i_state
	if p_skip==true and i_skip==true:
		pass
	else:
		state_change("player", player_state)
		state_change(cname, interactable_state[cname])
	return action	
	
func update_states(cname, targ_reached):
	var action
	
##### dd	
	if (cname == "dd_left") or (cname == "dd_right"):
		action = dd_state_decision(cname, targ_reached)
		var drink
		if cname == "dd_left":
			drink = obj_orange_drink
		else:
			drink = obj_cola_drink
		
		print("action is ",action)
		
		# pick up
		match action:
			"activate":
				_dd_active_sounds()
				stored_objects[cname] = [obj_empty_drink]
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_oh"], action)
			"timer":
				_dd_inactive_sounds()
				stored_objects[cname] = [drink]
		obj_change(cname, stored_objects[cname], action)

##### ms	
	elif (cname == "ms_left") or (cname == "ms_right"):
		action = ms_state_decision(cname, targ_reached)
		var raw_patty
		if cname == "ms_left":
			raw_patty = obj_raw_patty_1
		else:
			raw_patty = obj_raw_patty_2

		print("action is ",action)
	
		# pick up
		match action:
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = [raw_patty]
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = [raw_patty]
				obj_change("player", stored_objects["player_oh"], action)

##### f
	elif (cname == "f_1") or (cname == "f_2"):
		action = f_state_decision(cname, targ_reached)
		
		print("action is ", action)
		
		# pick up
		match action:
			"ph_up":
				_f_stop_sounds()
				_hand_sounds()
				if stored_objects[cname] == [obj_cooked_rings_pile_1]:
					stored_objects["player_ph"] = [obj_cooked_rings_1]
				elif stored_objects[cname] == [obj_cooked_fries_pile_1]:
					stored_objects["player_ph"] = [obj_cooked_fries_1]
				else:
					stored_objects["player_ph"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_f_stop_sounds()
				_hand_sounds()
				if stored_objects[cname] == [obj_cooked_rings_pile_1]:
					stored_objects["player_oh"] = [obj_cooked_rings_1]
				elif stored_objects[cname] == [obj_cooked_fries_pile_1]:
					stored_objects["player_oh"] = [obj_cooked_fries_1]
				else:
					stored_objects["player_oh"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_oh"], action)
			"ph_down":
				_f_active_sounds()
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = []
				obj_change("player", stored_objects["player_ph"], action)
				timer_manager.start_timer(cname)
			"oh_down":
				_f_active_sounds()
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = []
				obj_change("player", stored_objects["player_oh"], action)
				timer_manager.start_timer(cname)
			"ph_swap":
				_f_restart_sounds()
				_hand_sounds()
				var temp_obj_array = stored_objects[cname]
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = temp_obj_array
				obj_change("player", stored_objects["player_ph"], action)
				timer_manager.start_timer(cname)
			"oh_swap":
				_f_restart_sounds()
				_hand_sounds()
				var temp_obj_array = stored_objects[cname]
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = temp_obj_array
				obj_change("player", stored_objects["player_oh"], action)
				timer_manager.start_timer(cname)
			"timer":
				_f_inactive_sounds()
				if stored_objects[cname][0] == obj_frozen_fries_1:
					stored_objects[cname] = [obj_cooked_fries_pile_1]
				elif stored_objects[cname][0] == obj_frozen_rings_1:
					stored_objects[cname] = [obj_cooked_rings_pile_1]
			"timer2":
				if stored_objects[cname][0] == obj_cooked_fries_pile_1:
					stored_objects[cname] = [obj_burnt_fries_1]
				elif stored_objects[cname][0] == obj_cooked_rings_pile_1:
					stored_objects[cname] = [obj_burnt_rings_1]
				
		obj_change(cname, stored_objects[cname], action)

##### fs	
	elif (cname == "fs_1") or (cname == "fs_2"):
		action = fs_state_decision(cname, targ_reached)
		var frozen_stuff
		if cname == "fs_1":
			frozen_stuff = obj_frozen_fries_1
		else:
			frozen_stuff = obj_frozen_rings_1

		print("action is ",action)
	
		# pick up
		match action:
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = [frozen_stuff]
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = [frozen_stuff]
				obj_change("player", stored_objects["player_oh"], action)
		obj_change(cname, stored_objects[cname], action)

##### t	
	elif (cname == "t_1") or (cname == "t_2"):
		action = t_state_decision(cname, targ_reached)

		print("action is ",action)
	
		# pick up
		match action:
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_oh"], action)
			"ph_down":
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_down":
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = []
				obj_change("player", stored_objects["player_oh"], action)
			"ph_swap":
				var temp_array = stored_objects[cname]
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = temp_array
				obj_change("player", stored_objects["player_ph"], action)
		obj_change(cname, stored_objects[cname], action)

##### s
	elif (cname == "s_left") or (cname == "s_right"):
		action = s_state_decision(cname, targ_reached)
		
		print("action is ", action)
		
		# pick up
		match action:
			"ph_up":
				_s_stop_sounds()
				_hand_sounds()
				stored_objects["player_ph"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_s_stop_sounds()
				_hand_sounds()
				stored_objects["player_oh"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_oh"], action)
			"ph_down":
				_s_active_sounds()
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = []
				obj_change("player", stored_objects["player_ph"], action)
				timer_manager.start_timer(cname)
			"oh_down":
				_s_active_sounds()
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = []
				obj_change("player", stored_objects["player_oh"], action)
				timer_manager.start_timer(cname)
			"ph_swap":
				_s_restart_sounds()
				_hand_sounds()
				var temp_obj_array = stored_objects[cname]
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = temp_obj_array
				obj_change("player", stored_objects["player_ph"], action)
				timer_manager.start_timer(cname)
			"oh_swap":
				_s_restart_sounds()
				_hand_sounds()
				var temp_obj_array = stored_objects[cname]
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = temp_obj_array
				obj_change("player", stored_objects["player_oh"], action)
				timer_manager.start_timer(cname)
			"timer":
				_s_inactive_sounds()
				stored_objects[cname] = patty_reference(stored_objects[cname][0])
			"timer2":
				stored_objects[cname] = patty_reference(stored_objects[cname][0])
				
		obj_change(cname, stored_objects[cname], action)
	
##### bob
	elif (cname == "bob"):
		action = bob_state_decision(cname, targ_reached)
		
		print("action is ", action)
		
		# pick up
		match action:
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = bunify(stored_objects["player_ph"])
				print("here ph ", stored_objects["player_ph"])
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = bunify(stored_objects["player_oh"])
				print("here oh ",stored_objects["player_oh"])
				obj_change("player", stored_objects["player_oh"], action)
	
##### ts	
	elif (cname == "ts_1") or (cname == "ts_2") or (cname == "ts_3"):
		action = ts_state_decision(cname, targ_reached)
		var topping
		if cname == "ts_1":
			topping = obj_cheese_1
		elif cname == "ts_2":
			topping = obj_bacon_1
		else:
			topping = obj_lettuce_1
		
		print("action is ",action)
		
		# pick up
		match action:
			"ph_down":
				stored_objects[cname] = stored_objects["player_ph"]
				stored_objects["player_ph"] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_down":
				stored_objects[cname] = stored_objects["player_oh"]
				stored_objects["player_oh"] = []
				obj_change("player", stored_objects["player_oh"], action)
			"ph_up":
				_hand_sounds()
				stored_objects["player_ph"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_up":
				_hand_sounds()
				stored_objects["player_oh"] = stored_objects[cname]
				stored_objects[cname] = []
				obj_change("player", stored_objects["player_oh"], action)
			"timer":
				_dd_inactive_sounds()
				stored_objects[cname] = insert_topping(stored_objects[cname], topping)
		obj_change(cname, stored_objects[cname], action)
		
##### trash
	elif (cname == "trash"):
		action = trash_state_decision(cname, targ_reached)
		
		print("action is ", action)
		
		# pick up
		match action:
			"ph_down":
				stored_objects["player_ph"] = []
				obj_change("player", stored_objects["player_ph"], action)
			"oh_down":
				stored_objects["player_oh"] = []
				obj_change("player", stored_objects["player_oh"], action)
	
	else:
		print("cname not found: ", cname)

func insert_topping(input_array: Array, topping: String) -> Array:
	var topping_order = ["cheese", "bacon", "lettuce"]

	# Ensure we are not duplicating toppings
	if topping in input_array:
		return input_array

	# If only patty, then just apend and return
	if input_array.size() == 1:
		input_array.append(topping)
	# If patty and something else
	elif input_array.size() == 2:
		# If the array has cheese then we always append the new topping
		if obj_cheese_1 in input_array:
			input_array.append(topping)
		elif obj_lettuce_1 in input_array:
			input_array.insert(1, topping)
		# If we are adding cheese we know it must be in slot 1
		elif topping == obj_cheese_1:
			input_array.insert(1, topping)
		elif topping == obj_lettuce_1:
			input_array.append(topping)
			
		else:
			print("insert_topping: ERROR array: ", input_array, "failed to insert ", topping)
	elif input_array.size() == 3:
		if topping == obj_cheese_1:
			input_array.insert(1, topping)
		elif topping == obj_bacon_1:
			input_array.insert(2, topping)
		elif topping == obj_lettuce_1:
			input_array.append(topping)
			
		
	return input_array

func bunify(input_array):
	input_array.insert(0, obj_bot_bun)
	input_array.append(obj_top_bun)
	return input_array

func patty_reference(input):
	if input == obj_raw_patty_1:
		return [obj_cooked_patty_1]
	elif input == obj_raw_patty_2:
		return [obj_cooked_patty_2]
	elif input == obj_cooked_patty_1:
		return [obj_burnt_patty_1]
	elif input == obj_cooked_patty_2:
		return [obj_burnt_patty_2]

# stored objects
func update_i_sprites(target_node: Node, item_texture_paths: Array, start_position: Vector2):
	print("update_i_sprites: ", target_node, item_texture_paths)
	previous_sprite = null
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
		print("TEXTURE PATH IS: ", texture_path)
		var toppings_list = [obj_cheese_1, obj_bacon_1, obj_lettuce_1]
		var item_sprite = Sprite2D.new()
		item_sprite.texture = load(texture_path)
		
		# Set scale
		item_sprite.scale = Vector2(0.5, 0.5)

		# Set z_index of each array obj
		item_sprite.z_index = target_node.z_index + 1
		base_z_index += 1
		
		if texture_path in [obj_cooked_fries_1, obj_cooked_rings_1]:
			y_offset -= 4
		if texture_path in [obj_frozen_fries_1, obj_cooked_fries_pile_1, obj_burnt_fries_1, obj_frozen_rings_1, obj_cooked_rings_pile_1, obj_burnt_rings_1]:
			item_sprite.scale = Vector2(0.45, 0.45)
			y_offset += 1
		if texture_path == obj_lettuce_1 and previous_sprite == obj_bacon_1:
			y_offset += 0
		if texture_path == obj_cheese_1:
			y_offset += 4
			cheese = true
		if ((texture_path == obj_lettuce_1) or (texture_path == obj_top_bun)) and cheese == true:
			y_offset -= 4
			cheese = false
		if texture_path == obj_cooked_patty_2 and previous_sprite == obj_bot_bun:
			y_offset -= 2
		if texture_path in toppings_list:
			if texture_path == toppings_list[0]:
				y_offset -= 2
				item_sprite.position = start_position + Vector2(0, y_offset)  # Set position with offset
			else:
				item_sprite.position = start_position + Vector2(0, y_offset)  # Set position with offset
		elif texture_path == item_texture_paths[0]:
			item_sprite.position = start_position + Vector2(0, y_offset)  # Set position with offset
		else:
			y_offset -= 4
			item_sprite.position = start_position + Vector2(0, y_offset)  # Set position with offset
		target_node.add_child(item_sprite)  # Add sprite to parent

		y_offset -= 3  # Adjust scaled height
		previous_sprite = texture_path

func obj_change(sname, obj_array, action):
	if sname != "player":
		update_i_sprites(i_node[sname], obj_array, Vector2(0,0))
	obj_changed.emit(sname, obj_array, action)

func state_change(sname, state_array):
	state_changed.emit(sname, state_array)

func _on_player_reached_interactable(target: Vector2):
	# Parameter is where the player's last CMD was.
	# Find which command was used based on the vector.
	# Decrement the cmd_count and emit cmd name to obj.
	var cmd_name = null
	for key in coordinate_key.keys():
		if target in coordinate_key[key]:
			cmd_name = key
	if cmd_name == null:
		return
	var targ_reached = true
	update_states(cmd_name,targ_reached)
	cmd_count_decrement(cmd_name)
	emit_signal(cmd_name)

# Tell avatar where to go
func _on_player_where(pname, pos):
	if (pname == "o_1") or (pname == "o_2") or (pname == "o_3") or (pname == "o_4"):
		var chosen_cmd = cmd_seek(pname, pos)
		cmd_count_increment(pname)
		go_here.emit(chosen_cmd)
	elif cmd_count[pname] < cmd_count_max[pname]:
		var chosen_cmd = cmd_seek(pname, pos)
		cmd_count_increment(pname)
		go_here.emit(chosen_cmd)

# Find shortest distance coordinate
func cmd_seek(csname, pos):
	var distance = null
	var shortest_distance = INF
	var closest_command = null
	for command in coordinate_key[csname]:
		# Assign destination coordinate based on either the previous command
		# or based on player position if no previous command exists.
		if previous_command:
			distance = previous_command.distance_to(command)
		else:
			distance = pos.distance_to(command)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_command = command
	if closest_command:
		previous_command = closest_command
	else:
		previous_command = null
	return closest_command

func cmd_count_decrement(ccdname):
	# Make sure command doesn't have too many counts.
	if cmd_count[ccdname] >= cmd_count_max[ccdname]:
		cmd_count[ccdname] = cmd_count_max[ccdname]
		
	if cmd_count[ccdname] > 0:
		cmd_count[ccdname] -= 1
	else:
		cmd_count[ccdname] = 0
	return ccdname

func cmd_count_increment(cciname):
	# Make sure command doesn't have negative counts
	if cmd_count[cciname] < 1:
		cmd_count[cciname] = 0
	
	if cmd_count[cciname] >= cmd_count_max[cciname]:
		cmd_count[cciname] = cmd_count_max[cciname]
	else:
		cmd_count[cciname] += 1

# Update global player state array
func _on_player_state_changed(state_array_p):
	player_state = state_array_p

func _on_interactables_state_changed(cname, state_array_i):
	interactable_state[cname] = state_array_i
	
func _on_timer_timer_expired(timer_id: String):
	if (timer_id == "dd_left") or (timer_id == "dd_right"):
		interactable_state[timer_id] = [1,0,1]
	
	if (timer_id == "ts_1") or (timer_id == "ts_2") or (timer_id == "ts_3"):
		interactable_state[timer_id] = [1,0,1]
		
	if (timer_id == "s_left") or (timer_id == "s_right") or (timer_id == "f_1") or (timer_id == "f_2"):
		# stove activating / raw laden
		if interactable_state[timer_id] == [0,1,1]:
			interactable_state[timer_id] = [1,1,1]
			timer_manager.start_timer(timer_id)
		# stove activating / cooked laden
		elif interactable_state[timer_id] == [1,1,1]:
			interactable_state[timer_id] = [0,0,1]
	var targ_reached = false
	update_states(timer_id, targ_reached)

func _hand_sounds():
	var audio_player = $Sounds/hand
	var sound = load("res://Sounds/swing.wav")
	audio_player.stream = sound
	audio_player.play()

func _dd_active_sounds():
	var audio_player = $Sounds/dd_aud_1
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $Sounds/dd_aud_2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()
	
func _dd_inactive_sounds():
	var audio_player3 = $Sounds/dd_aud_3
	var sound3 = load("res://Sounds/click_2.mp3")
	audio_player3.stream = sound3
	audio_player3.play()

func _s_active_sounds():
	var audio_player = $Sounds/s_aud_1
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $Sounds/s_aud_2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()
	
func _s_inactive_sounds():
	var audio_player3 = $Sounds/s_aud_3
	var sound3 = load("res://Sounds/click_2.mp3")
	audio_player3.stream = sound3
	audio_player3.play()

func _s_stop_sounds():
	var audio_player = $Sounds/s_aud_1
	if audio_player.is_playing():
		audio_player.stop()
	var audio_player2 = $Sounds/s_aud_2
	if audio_player2.is_playing():
		audio_player2.stop()
		
func _s_restart_sounds():
	var audio_player = $Sounds/s_aud_1
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $Sounds/s_aud_2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()

func _f_active_sounds():
	var audio_player = $Sounds/f_aud_1
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $Sounds/f_aud_2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()

func _f_inactive_sounds():
	var audio_player3 = $Sounds/f_aud_3
	var sound3 = load("res://Sounds/click_2.mp3")
	audio_player3.stream = sound3
	audio_player3.play()

func _f_stop_sounds():
	var audio_player = $Sounds/f_aud_1
	if audio_player.is_playing():
		audio_player.stop()
	var audio_player2 = $Sounds/f_aud_2
	if audio_player2.is_playing():
		audio_player2.stop()
		
func _f_restart_sounds():
	var audio_player = $Sounds/f_aud_1
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $Sounds/f_aud_2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()
