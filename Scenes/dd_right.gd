extends Node2D

######################################################
# 	dd_right
######################################################

var enabled = true
var active = false
var laden = false

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_cola = $cup_cola

func _ready():
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))

func _process(delta):
	pass

func _on__burgers_dd_right():
	# Avatar reached this command
	if active:
		print("dd_right: busy dispensing")
	else:
		if laden:
			print("dd_right: okay to pick up")
			laden = false
			cup_cola.visible = false
			return 1
		else:
			# ACTIVATE
			active = true
			cup_empty.visible = true
			timer_manager.start_timer("dd_right")
			print("dd_right: activated")
		

func _on_timer_expired(timer_id: String):
	if timer_id == "dd_right":
		active = false
		cup_empty.visible = false
		laden = true
		cup_cola.visible = true
		print("dd_right: laden")

func start_round_timer():
	timer_manager.start_timer("round")
