extends Node2D

var enabled = true
var active = false
var laden = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on__burgers_dd_left():
# Avatar reached this command
	if active:
		print("DD is busy dispensing")
		# BUSY - ERROR
	elif not active:
		if laden:
			# OKAY TO PICK UP
			return 1
		elif not laden:
			# ACTIVATE
			active = true
			print("dd_left reporting in")
