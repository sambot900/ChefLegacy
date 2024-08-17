extends Node2D


######################################################
# 	dd_left
######################################################

signal activated
signal deactivated
signal ladened
signal unladened

var enabled = true
var active = false
var laden = false

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_oj = $cup_oj

func _ready():
	active = false
	laden = false
	deactivated.emit("dd_left")
	unladened.emit("dd_left")
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))

func _process(delta):
	pass

func _on__burgers_dd_left():
	# Avatar reached this command
	if active:
		print("dd_left: busy dispensing")
	else:
		if laden:
			print("dd_left: okay to pick up")
			unladened.emit("dd_left")
			laden = false
			cup_oj.visible = false
		else:
			cup_oj.visible = false
			# ACTIVATE
			active = true
			activated.emit("dd_left")
			cup_empty.visible = true
			timer_manager.start_timer("dd_left")
			print("dd_left: activated")
		

func _on_timer_expired(timer_id: String):
	if timer_id == "dd_left":
		deactivated.emit("dd_left")
		active = false
		
		cup_empty.visible = false
		ladened.emit("dd_left")
		laden = true
		cup_oj.visible = true
		print("dd_left: laden")

func start_round_timer():
	timer_manager.start_timer("round")
