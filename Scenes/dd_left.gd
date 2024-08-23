extends Node2D

######################################################
# 	dd_left
######################################################

var enabled = true
var active = false
var laden = false
var cmd_name = "dd_left"

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_oj = $cup_oj

func _ready():
	enabled = true
	active = false
	laden = false
	timer_manager.connect("timer_expired", Callable(self, "_on_timer_expired"))

func _process(_delta):
	pass

# Avatar reached this command
# determine state
# emit state


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
	print("now laden ", cmd_name)
	audio_player3.stream = sound3
	audio_player3.play()

func start_round_timer():
	timer_manager.start_timer("round")

func _on_interactables_dd_left(state_array):
	if state_array:
		enabled = state_array[0]
		active = state_array[1]
		laden = state_array[2]
	if state_array:
		if 	state_array==  [1,0,0]: # common case: enabled, inactive, unladen
			_inactive_sounds()
			cup_oj.visible = 	false
			cup_empty.visible = false
		elif state_array== [1,1,0]: # common case: enabled, active, unladen
			_active_sounds()
			cup_oj.visible = 	false			
			cup_empty.visible = true
			# dispensing animation
			pass
		elif state_array== [1,0,1]: # common case: enabled, inactive, laden
			cup_oj.visible = true
			cup_empty.visible = false
		elif state_array== [0,0,0]: # case: disabled
			pass
		else:					   # case: else
			print("error: state error")
