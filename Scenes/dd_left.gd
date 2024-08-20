extends Node2D

######################################################
# 	dd_left
######################################################

signal state_changed(state_array: Array)

var enabled = true
var active = false
var laden = false

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_oj = $cup_oj

func _ready():
	enabled = true
	active = false
	laden = false
	emit_state()
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))

func _process(delta):
	pass

func get_state() -> Array:
	var enabled_state = 1 if enabled else 0
	var active_state = 1 if active else 0
	var laden_state = 1 if laden else 0
	return [enabled_state, active_state, laden_state]

func emit_state():
	var state = get_state()
	state_changed.emit(state)
	
	if state[0] == 1:
		# enabled
		self.visible = true
	else:
		# disabled
		self.visible = false
	
	if state[1] == 1:
		# activated
		_active_sounds()
	else:
		# deactivated
		pass
		
	
	if state[2] == 1:
		# laden
		_inactive_sounds()
	else:
		# unladen
		pass

# Avatar reached this command
# determine state
# emit state
func _on__burgers_dd_left():
	# determine state
	if active:
		print("dd_left: busy dispensing")
	else:
		if laden:
			print("dd_left: okay to pick up")
			laden = false
			cup_oj.visible = false
		else:
			cup_oj.visible = false
			active = true
			cup_empty.visible = true
			timer_manager.start_timer("dd_left")
	# emit state
	emit_state()

func _active_sounds():
	var audio_player = $ddaudio
	var sound = load("res://Sounds/fire_2.mp3")
	audio_player.stream = sound
	audio_player.play()
	var audio_player2 = $ddaudio2
	var sound2 = load("res://Sounds/click_1.mp3")
	audio_player2.stream = sound2
	audio_player2.play()
	
func _inactive_sounds():
	var audio_player3 = $ddaudio3
	var sound3 = load("res://Sounds/click_2.mp3")
	audio_player3.stream = sound3
	audio_player3.play()

func _on_timer_expired(timer_id: String):
	if timer_id == "dd_left":
		active = false
		laden = true
		cup_empty.visible = false
		cup_oj.visible = true
	
	emit_state()

func start_round_timer():
	timer_manager.start_timer("round")
