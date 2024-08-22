extends Node2D

######################################################
# 	Interactables
######################################################

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


var states = {}

func _ready():
	# Initialize states for all interactables (if needed)
	states["dd_left"] = [1,0,0]
	states["dd_right"] = [1,0,0]
	# Add more initial states as necessary

func _on__burgers_state_changed(cname: String, state_array: Array):
	# Store the state in the dictionary
	states[cname] = state_array
	emit_signal(cname, state_array)
	print("NAME IS: ", get_state(cname))

func get_state(cname: String) -> Array:
	# Return the state of the specified interactable
	if states.has(cname):
		return states[cname]
	else:
		print("No state found for:", cname)
		return []
