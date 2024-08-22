extends Control

######################################################
# 	UI
######################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	var _back_button = $back_button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_back_button_pressed():
	get_tree().quit()
