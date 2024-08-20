extends Timer

var timers = {}
var initial_durations = {}

func _ready():
	connect("timeout", Callable(self, "_on_timeout"))
	initialize_timers()

func initialize_timers():
	initial_durations["round"] = 65.0
	initial_durations["combo1"] = 2.0
	initial_durations["combo2"] = 5.0
	initial_durations["combo3"] = 8.0
	initial_durations["dd_left"] = 4.1
	initial_durations["dd_right"] = 5.0
	initial_durations["s_left"] = 8.0
	initial_durations["s_right"] = 8.0
	initial_durations["ts_1"] = 6.0
	initial_durations["ts_2"] = 6.0
	initial_durations["ts_3"] = 6.0
	initial_durations["f_1"] = 2.0
	initial_durations["f_2"] = 2.0
	
	for key in initial_durations.keys():
		timers[key] = {"remaining_time": initial_durations[key], "active": false}

func start_timer(timer_id: String):
	if timer_id in timers:
		timers[timer_id]["active"] = true
		timers[timer_id]["remaining_time"] = initial_durations[timer_id]
	if is_stopped():
		start(0.1)  # Start the timer with a short interval to check every 0.1 seconds

func _on_timeout():
	for key in timers.keys():
		if timers[key]["active"]:
			timers[key]["remaining_time"] -= 0.1
			if timers[key]["remaining_time"] <= 0:
				timers[key]["active"] = false
				emit_signal("timer_expired", key)
	# Check if there are any active timers left
	if not timers.values().any(func(value): return value["active"]):
		stop()
	else:
		start(0.1)

# Signal to notify when a timer expires
signal timer_expired(timer_id: String)
