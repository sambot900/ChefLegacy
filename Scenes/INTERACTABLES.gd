extends Node2D

######################################################
# 	Interactables
######################################################

signal state_changed(state_array: Array)
signal dd_left
signal dd_right
signal ms_left
signal ms_right
signal s_left
signal s_right
signal ts_1
signal ts_2
signal ts_3
signal f_1
signal f_2
signal fs_1
signal fs_2
signal t_1
signal t_2
signal bob
signal o_1
signal o_2
signal o_3
signal o_4

var keys = []
var states = {}

func _ready():
	# Initialize states for all interactables (if needed)
	states["dd_left"] = [1,0,0]
	states["dd_right"] = [1,0,0]
	states["ms_left"] = [1,0,1]
	states["ms_right"] = [1,0,1]
	states["s_left"] = [0,0,0]
	states["s_right"] = [0,0,0]
	states["ts_1"] = [1,0,0] # enabled for testing
	states["ts_2"] = [0,0,0] # disabled for testing
	states["ts_3"] = [0,0,0] # disabled for testing
	states["f_1"] = [1,0,0]
	states["f_2"] = [1,0,0]
	states["fs_1"] = [1,0,0]
	states["fs_2"] = [0,0,0]
	states["t_1"] = [1,0,0]
	states["t_2"] = [1,0,0]
	states["bob"] = [1,0,0]
	states["o_1"] = [1,0,0] # enabled when a customer is there... but for now...
	states["o_2"] = [1,0,0]
	states["o_3"] = [1,0,0]
	states["o_4"] = [1,0,0]
	for key in states.keys():
		keys.append(key)
		emit_state(key)
	
	# Add more initial states as necessary

func emit_state(cname):
	var state = get_state(cname)
	state_changed.emit(cname, state)

func _on__burgers_state_changed(cname: String, state_array: Array):
	if state_array != [9,9,9]:
		if cname == "player":
			return
		# Store the state in the dictionary
		states[cname] = state_array
		
		# Emit the signal if it exists
		if has_signal(cname):
			emit_signal(cname, state_array)
			#print(cname, ":i:", get_state(cname))
		else:
			print("Signal not found for:", cname)

func get_state(cname: String) -> Array:
	# Return the state of the specified interactable
	if states.has(cname):
		return states[cname]
	else:
		print("No state found for:", cname)
		return [3,3,3]

