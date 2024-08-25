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
#endregion

#region Dictionary Init: coordinate_key
var coordinate_key = {
	"dd_left": [Vector2(307, 423), Vector2(337, 423), Vector2(367, 423)],
	"dd_right": [Vector2(379, 423), Vector2(409, 423), Vector2(439, 423)],
	"ms_left": [Vector2(524, 14), Vector2(554, 14), Vector2(584, 14)],
	"ms_right": [Vector2(601, 14), Vector2(625, 14), Vector2(649, 14)],
	"fs_1": [Vector2(653, 265), Vector2(653, 295), Vector2(653, 325)],
	"fs_2": [Vector2(653, 329), Vector2(653, 359), Vector2(653, 389)],
	"s_left": [Vector2(318, -9), Vector2(348, -9), Vector2(378, -9)],
	"s_right": [Vector2(444, -9), Vector2(474, -9), Vector2(504, -9)],
	"ts_1": [Vector2(320, 55), Vector2(350, 55), Vector2(380, 55), Vector2(238, 110), Vector2(238, 140), Vector2(238, 170), Vector2(320, 180), Vector2(350, 180), Vector2(380, 180)],
	"ts_2": [Vector2(407, 55), Vector2(437, 55), Vector2(467, 55), Vector2(407, 180), Vector2(437, 180), Vector2(467, 180)],
	"ts_3": [Vector2(495, 55), Vector2(525, 55), Vector2(555, 55), Vector2(612, 108), Vector2(612, 138), Vector2(612, 144), Vector2(495, 180), Vector2(525, 180), Vector2(555, 180)],
	"f_1": [Vector2(653, 133), Vector2(653, 148), Vector2(653, 163)],
	"f_2": [Vector2(653, 185), Vector2(653, 200), Vector2(653, 215)],
	"t_1": [Vector2(653, 428), Vector2(653, 453), Vector2(653, 478)],
	"t_2": [Vector2(653, 494), Vector2(653, 519), Vector2(653, 544)],
	"bob": [Vector2(653, 21), Vector2(653, 46), Vector2(653, 71)],
	"o_1": [Vector2(292, 572)],
	"o_2": [Vector2(424, 572)],
	"o_3": [Vector2(558, 572)],
	"o_4": [Vector2(686, 572)]
}
#endregion

#region Dictionary Init: cmd_count
var cmd_count = {
	"dd_left": 0,
	"dd_right": 0,
	"ms_left": 0,
	"ms_right": 0,
	"fs_1": 0,
	"fs_2": 0,
	"s_left": 0,
	"s_right": 0,
	"ts_1": 0,
	"ts_2": 0,
	"ts_3": 0,
	"f_1": 0,
	"f_2": 0,
	"t_1": 0,
	"t_2": 0,
	"bob": 0,
	"o_1": 0,
	"o_2": 0,
	"o_3": 0,
	"o_4": 0
}

var cmd_count_max = {
	"dd_left": 2,
	"dd_right": 2,
	"ms_left": 2,
	"ms_right": 2,
	"fs_1": 2,
	"fs_2": 2,
	"s_left": 2,
	"s_right": 2,
	"ts_1": 2,
	"ts_2": 2,
	"ts_3": 2,
	"f_1": 2,
	"f_2": 2,
	"t_1": 2,
	"t_2": 2,
	"bob": 2,
	"o_1": 1,
	"o_2": 1,
	"o_3": 1,
	"o_4": 1
	}
#endregion

var checkmarks = {}
var player_state = []
var interactable_state = {}
var interactables_accepts = {}
var interactables_objects = {}
var previous_command
var order_1 = []
var order_2 = []
var order_3 = []
var order_4 = []


#region Declarations
@onready var dd_left_check1 = $"INTERACTABLES/DrinkDispenser/dd_left/CMD icons/check2"
@onready var dd_left_check2 = $"INTERACTABLES/DrinkDispenser/dd_left/CMD icons/check1"
@onready var dd_right_check1 = $"INTERACTABLES/DrinkDispenser/dd_right/CMD icons/check2"
@onready var dd_right_check2 = $"INTERACTABLES/DrinkDispenser/dd_right/CMD icons/check1"
@onready var ms_left_check1 = $"INTERACTABLES/MeatSource1/Ms1/CMD icons/check2"
@onready var ms_left_check2 = $"INTERACTABLES/MeatSource1/Ms1/CMD icons/check1"
@onready var ms_right_check1 = $"INTERACTABLES/MeatSource2/Ms2/CMD icons/check2"
@onready var ms_right_check2 = $"INTERACTABLES/MeatSource2/Ms2/CMD icons/check1"
@onready var fs_1_check1 = $"INTERACTABLES/Freezer/fs_1/CMD icons/check2"
@onready var fs_1_check2 = $"INTERACTABLES/Freezer/fs_1/CMD icons/check1"
@onready var fs_2_check1 = $"INTERACTABLES/Freezer/fs_2/CMD icons/check2"
@onready var fs_2_check2 = $"INTERACTABLES/Freezer/fs_2/CMD icons/check1"
@onready var s_left_check1 = $"INTERACTABLES/Stove/s1_left/CMD icons/check2"
@onready var s_left_check2 = $"INTERACTABLES/Stove/s1_left/CMD icons/check1"
@onready var s_right_check1 = $"INTERACTABLES/Stove/s1_right/CMD icons/check2"
@onready var s_right_check2 = $"INTERACTABLES/Stove/s1_right/CMD icons/check1"
@onready var ts_1_check1 = $"INTERACTABLES/TOPPING STATION/TsBoardCheese/CMD icons/check2"
@onready var ts_1_check2 = $"INTERACTABLES/TOPPING STATION/TsBoardCheese/CMD icons/check1"
@onready var ts_2_check1 = $"INTERACTABLES/TOPPING STATION/TsBoardBacon/CMD icons/check2"
@onready var ts_2_check2 = $"INTERACTABLES/TOPPING STATION/TsBoardBacon/CMD icons/check1"
@onready var ts_3_check1 = $"INTERACTABLES/TOPPING STATION/TsBoardLettuce/CMD icons/check2"
@onready var ts_3_check2 = $"INTERACTABLES/TOPPING STATION/TsBoardLettuce/CMD icons/check1"
@onready var f_1_check1 = $"INTERACTABLES/Fryer/f_1/CMD icons/check2"
@onready var f_1_check2 = $"INTERACTABLES/Fryer/f_1/CMD icons/check1"
@onready var f_2_check1 = $"INTERACTABLES/Fryer/f_2/CMD icons/check2"
@onready var f_2_check2 = $"INTERACTABLES/Fryer/f_2/CMD icons/check1"
@onready var t_1_check1 = $"INTERACTABLES/HelperTray1/HelperTray/CMD icons/check2"
@onready var t_1_check2 = $"INTERACTABLES/HelperTray1/HelperTray/CMD icons/check1"
@onready var t_2_check1 = $"INTERACTABLES/HelperTray2/HelperTray/CMD icons/check2"
@onready var t_2_check2 = $"INTERACTABLES/HelperTray2/HelperTray/CMD icons/check1"
@onready var bob_check1 = $"INTERACTABLES/BOB/CMD icons/check2"
@onready var bob_check2 = $"INTERACTABLES/BOB/CMD icons/check1"
@onready var o_1_check1 = $"INTERACTABLES/o_1/CMD icons/check1"
@onready var o_2_check1 = $"INTERACTABLES/o_2/CMD icons/check1"
@onready var o_3_check1 = $"INTERACTABLES/o_3/CMD icons/check1"
@onready var o_4_check1 = $"INTERACTABLES/o_4/CMD icons/check1"
@onready var cook_avatar = $Player
@onready var cmds_node = $CMDs
@onready var round_camera = $RoundCamera
@onready var camera_animation_player = $CameraAnimationPlayer
@onready var dd = $INTERACTABLES/DrinkDispenser
@onready var freezer = $INTERACTABLES/Freezer
#endregion

func _ready():
	# Initialize the checkmarks dictionary
	checkmarks = {
		"dd_left": [dd_left_check1, dd_left_check2],
		"dd_right": [dd_right_check1, dd_right_check2],
		"ms_left": [ms_left_check1, ms_left_check2],
		"ms_right": [ms_right_check1, ms_right_check2],
		"fs_1": [fs_1_check1, fs_1_check2],
		"fs_2": [fs_2_check1, fs_2_check2],
		"s_left": [s_left_check1, s_left_check2],
		"s_right": [s_right_check1, s_right_check2],
		"ts_1": [ts_1_check1, ts_1_check2],
		"ts_2": [ts_2_check1, ts_2_check2],
		"ts_3": [ts_3_check1, ts_3_check2],
		"f_1": [f_1_check1, f_1_check2],
		"f_2": [f_2_check1, f_2_check2],
		"t_1": [t_1_check1, t_1_check2],
		"t_2": [t_2_check1, t_2_check2],
		"bob": [bob_check1, bob_check2],
		"o_1": [o_1_check1],
		"o_2": [o_2_check1],
		"o_3": [o_3_check1],
		"o_4": [o_4_check1]
	}
	
	interactables_accepts["dd_left"] = []
	interactables_accepts["dd_right"] = []
	interactables_accepts["ms_left"] = []
	interactables_accepts["ms_right"] = []
	interactables_accepts["s_left"] = ["raw_patty_1", "raw_patty_2"]
	interactables_accepts["s_right"] = ["raw_patty_1", "raw_patty_2"]
	interactables_accepts["ts_1"] = ["cooked_patty1", "cooked_patty2", "bacon_1", "lettuce_1"]
	interactables_accepts["ts_2"] = ["cooked_patty1", "cooked_patty2", "cheese_1", "lettuce_1"]
	interactables_accepts["ts_3"] = ["cooked_patty1", "cooked_patty2", "cheese_1", "bacon_1"]
	interactables_accepts["f_1"] = ["frozen_fries_1", "frozen_fries_2", "frozen_rings_1", "frozen_rings_2"]
	interactables_accepts["f_2"] = ["frozen_fries_1", "frozen_fries_2", "frozen_rings_1", "frozen_rings_2"]
	interactables_accepts["fs_1"] = []
	interactables_accepts["fs_2"] = []
	interactables_accepts["t_1"] = "any"
	interactables_accepts["t_2"] = "any"
	interactables_accepts["bob"] = []
	interactables_accepts["o_1"] = order_1
	interactables_accepts["o_2"] = order_2
	interactables_accepts["o_3"] = order_3
	interactables_accepts["o_4"] = order_4
	
	interactables_objects["dd_left"] = []
	interactables_objects["dd_right"] = []
	interactables_objects["ms_left"] = []
	interactables_objects["ms_right"] = []
	interactables_objects["s_left"] = []
	interactables_objects["s_right"] = []
	interactables_objects["ts_1"] = []
	interactables_objects["ts_2"] = []
	interactables_objects["ts_3"] = []
	interactables_objects["f_1"] = []
	interactables_objects["f_2"] = []
	interactables_objects["fs_1"] = []
	interactables_objects["fs_2"] = []
	interactables_objects["t_1"] = []
	interactables_objects["t_2"] = []
	interactables_objects["bob"] = []

	#print("player state:<<init>> ", player_state)
	#print("interactable state:<<init>> ", interactable_state)

func _input(_event):
	pass

func start_camera_pan():
	if round_camera and camera_animation_player:
		camera_animation_player.play("PanCamera")
	else:
		print("Camera and AnimationPlayer not found")

func dd_state_decision(cname, targ_reached):
	var action = 0 # 0=no action, 1=ph pick up, 2=oh pick up, 3=ph set down, 4=oh set down, 5=ph swap, 6=oh swap
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
				print("p:full i:idle -> i:active")
				p_state = [1,1,1]
				i_state = [1,1,0]
			print("targ_reached = ", targ_reached)
			
		elif state ==	 [1,       0,       1,         1,        0,       0]:
			if targ_reached:
				print("p:oh i:idle -> i:active")
				p_state = [1,0,1]
				i_state = [1,1,0]
			print("targ_reached = ", targ_reached)
			
		elif state == 	 [1,       1,       0,         1,        0,       0]:
			if targ_reached:
				print("p:ph i:idle -> i:active")
				p_state = [1,1,0]
				i_state = [1,1,0]
			print("targ_reached = ", targ_reached)
		elif state == 	 [1,       0,       0,         1,        0,       0]:
			if targ_reached:
				print("p:empty i:idle -> i:active")
				p_state = [1,0,0]
				i_state = [1,1,0]
			print("targ_reached = ", targ_reached)
			###########################################################################
		elif state == 	 [1,       1,       1,         1,        1,       0]: # active
			if targ_reached:
				print("p:full i:busy -> same")
				p_skip = true
				i_skip = true
			print("targ_reached = ", targ_reached)
			
		elif state == 	 [1,       0,       1,         1,        1,       0]:
			if targ_reached:
				print("p:oh i:busy -> same")
				p_skip = true
				i_skip = true
			print("targ_reached = ", targ_reached)
			
		elif state == 	 [1,       1,       0,         1,        1,       0]:
			if targ_reached:
				print("p:ph i:busy -> same")
				p_skip = true
				i_skip = true
			print("targ_reached = ", targ_reached)
			
		elif state == 	 [1,       0,       0,         1,        1,       0]:
			if targ_reached:
				print("p:empty i:busy -> same")
				p_skip = true
				i_skip = true
			print("targ_reached = ", targ_reached)
			
			###########################################################################				
		elif state == 	 [1,       1,       1,         1,        0,       1]: # laden
			if targ_reached:
				print("p:full i:laden -> same")
				p_skip = true
				i_skip = true
			else:
				p_skip = true
				i_skip = true
			print("targ_reached = ", targ_reached)
			
			action = 0
		elif state == 	 [1,       0,       1,         1,        0,       1]:
			if targ_reached:
				print("p:oh i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = 1
			print("targ_reached = ", targ_reached)
			
		elif state ==	 [1,       1,       0,         1,        0,       1]:
			if targ_reached:
				print("p:ph i:laden -> p:full i:idle")
				p_state = [1,1,1]
				i_state = [1,0,0]
				action = 2
			print("targ_reached = ", targ_reached)
			
		elif state ==	 [1,       0,       0,         1,        0,       1]:
			if targ_reached:
				print("p:empty i:laden -> p:ph i:idle")
				p_state = [1,1,0]
				i_state = [1,0,0]
				action = 1
			print("targ_reached = ", targ_reached)
			
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
			
func update_states(cname, targ_reached):
	if cname == "dd_left" or cname == "dd_right":
		dd_state_decision(cname, targ_reached)
	else:
		print("cname not found: ", cname)


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
	manage_cmd_icons(cmd_name)
	emit_signal(cmd_name)
	
# Command icon visibility management
func manage_cmd_icons(cname):
	var count = cmd_count[cname]
	if cname in checkmarks:
		var checks = checkmarks[cname]
		if checks.size() == 2:
			checks[0].visible = count >= 1
			checks[1].visible = count >= 2
		elif checks.size() == 1:
			checks[0].visible = count >= 1
	else:
		print("ERROR - manage_cmd_vis: unknown command ", cname)

# Tell avatar where to go
func _on_player_where(pname, pos):
	if (pname == "o_1") or (pname == "o_2") or (pname == "o_3") or (pname == "o_4"):
		var chosen_cmd = cmd_seek(pname, pos)
		cmd_count_increment(pname)
		manage_cmd_icons(pname)
		go_here.emit(chosen_cmd)
	elif cmd_count[pname] < cmd_count_max[pname]:
		var chosen_cmd = cmd_seek(pname, pos)
		cmd_count_increment(pname)
		manage_cmd_icons(pname)
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

func _on_player_state_changed(state_array_p):
	player_state = state_array_p

func _on_interactables_state_changed(cname, state_array_i):
	interactable_state[cname] = state_array_i
	var targ_reached = false
	update_states(cname, targ_reached)
	
func _on_timer_timer_expired(timer_id: String):
	interactable_state[timer_id] = [1,0,1]
	var targ_reached = false
	update_states(timer_id, targ_reached)
	emit_signal(timer_id)
