extends Node2D

var enabled = true
var active = false
var laden = false

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."

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
			# OKAY TO PICK UP
			return 1
		else:
			# ACTIVATE
			active = true
			timer_manager.start_timer("dd_right")
			add_oj_sprite()
			print("dd_right: activated")

func _on_timer_expired(timer_id: String):
	if timer_id == "dd_right":
		active = false
		laden = true
		print("dd_right: laden")

func start_round_timer():
	timer_manager.start_timer("round")

func add_oj_sprite():
	if not drink_dispenser.has_node("oj"):
		var oj_sprite = Sprite2D.new()
		oj_sprite.name = "oj"
		#oj_sprite.texture = preload("res://path/to/oj_texture.png")  # Adjust the path to your orange juice texture
		drink_dispenser.add_child(oj_sprite)
