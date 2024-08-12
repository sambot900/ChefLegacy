extends Node2D  # This script should be attached to the 'Round' node

@onready var cook_avatar = $Player
@onready var cmds_node = $CMDs
@onready var round_camera = $RoundCamera
@onready var camera_animation_player = $CameraAnimationPlayer

func _ready():
	print("Round node ready")
	start_camera_pan()

func _input(event):
	pass

func start_camera_pan():
	if round_camera and camera_animation_player:
		camera_animation_player.play("PanCamera")
	else:
		print("Camera and AnimationPlayer not found")  # Debug print


func _on_player_reached_interactable(target):
	print("target reached: ", target)
