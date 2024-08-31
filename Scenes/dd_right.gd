extends Node2D

######################################################
# 	dd_right
######################################################

var cmd_name = "dd_right"

@onready var timer_manager = $"../../../Timer"
@onready var drink_dispenser = $".."
@onready var cup_empty = $cup_empty
@onready var cup_cola = $cup_cola

func _ready():
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
	audio_player3.stream = sound3
	audio_player3.play()

func start_round_timer():
	timer_manager.start_timer("round")

func _on_interactables_dd_right(state_array):
	if state_array and (state_array != [9,9,9]):
		if 	state_array ==  [1,0,0]: # common case: enabled, inactive, unladen
			cup_cola.visible = 	false
			cup_empty.visible = false
		elif state_array== [1,1,0]: # common case: enabled, active, unladen
			timer_manager.start_timer(cmd_name)
			_active_sounds()
			cup_cola.visible = 	false			
			cup_empty.visible = true
			# dispensing animation
			pass
		elif state_array== [1,0,1]: # common case: enabled, inactive, laden
			_inactive_sounds()
			cup_cola.visible = true
			cup_empty.visible = false
		elif state_array== [0,0,0]: # case: disabled
			pass
		else:					   # case: else
			print("error: state error")

func _on_timer_expired(timer_id: String):
	pass
	#if timer_id == cmd_name:
		#_inactive_sounds()
		#cup_empty.visible = false
		#cup_oj.visible = true
