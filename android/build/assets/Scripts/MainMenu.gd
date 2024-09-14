extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the signal emitted by the StartButton in the MainMenu scene
	var start_button = get_node("StartButton")
	if start_button:
		start_button.pressed.connect(Callable(self, "_on_StartButton_pressed"))

# Method to handle the start button pressed event
func _on_StartButton_pressed():
	# Load the Round scene
	var round_scene = load("res://Scenes/Round.tscn")
	var round_instance = round_scene.instantiate()

	# Add the Round scene as a child of the current scene
	get_tree().get_root().add_child(round_instance)

	# Optionally, remove the MainMenu scene if it's no longer needed
	queue_free()
