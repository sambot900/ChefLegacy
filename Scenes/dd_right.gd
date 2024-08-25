extends Node2D

######################################################
# 	dd_left
######################################################

var enabled = true
var active = false
var laden = false
var cmd_name = "dd_right"

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_cola = $cup_cola

func _ready():
	enabled = true
	active = false
	laden = false
	emit_state()
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))

func _process(_delta):
	pass

func get_state() -> Array:
	var enabled_state = 1 if enabled else 0
	var active_state = 1 if active else 0
	var laden_state = 1 if laden else 0
	return [enabled_state, active_state, laden_state]

func emit_state():
	var state = get_state()
	
	if state[0] == 1:
		pass

# Avatar reached this command
# determine state
# emit state
func _on__burgers_dd_right():
	if enabled:
	# determine state
		if active:
			pass
		else:
			if laden:
				laden = false
				cup_cola.visible = false
			else:
				_active_sounds()
				cup_cola.visible = false
				active = true
				cup_empty.visible = true
				timer_manager.start_timer(cmd_name)
		# emit state
			emit_state()
	else:
		pass

func _active_sounds():
	var audio_player5 = $ddaudio5
	var sound5 = load("res://Sounds/fire_2.mp3")
	audio_player5.stream = sound5
	audio_player5.play()
	var audio_player6 = $ddaudio6
	var sound6 = load("res://Sounds/click_1.mp3")
	audio_player6.stream = sound6
	audio_player6.play()
	
func _inactive_sounds():
	var audio_player7 = $ddaudio7
	var sound7 = load("res://Sounds/click_2.mp3")
	audio_player7.stream = sound7
	audio_player7.play()

func _on_timer_expired(timer_id: String):
	if timer_id == cmd_name:
		_inactive_sounds()
		active = false
		laden = true
		cup_empty.visible = false
		cup_cola.visible = true
	
	emit_state()

func start_round_timer():
	timer_manager.start_timer("round")
