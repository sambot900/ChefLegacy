extends Node2D

#region Signal Declarations
signal dd_left
signal dd_right
signal ms_left
signal ms_right
signal fs_1
signal fs_2
signal s_left
signal s_right
signal ts_1
signal ts_2
signal ts_3
signal f_1
signal f_2
signal t_1
signal t_2
signal bob
signal o_1
signal o_2
signal o_3
signal o_4
#endregion


#region Coordinate Key
var coordinate_key = {
	"dd_left": [Vector2(307, 423), Vector2(337, 423), Vector2(367, 423)],
	"dd_right": [Vector2(379, 423), Vector2(409, 423), Vector2(439, 423)],
	"ms_left": [Vector2(524, 14), Vector2(554, 14), Vector2(584, 14)],
	"ms_right": [Vector2(601, 14), Vector2(625, 14), Vector2(649, 14)],
	"fs_1": [Vector2(653, 265), Vector2(653, 295), Vector2(653, 325)],
	"fs_2": [Vector2(653, 329), Vector2(653, 359), Vector2(653, 389)],
	"s_left": [Vector2(318, -9), Vector2(348, -9), Vector2(378, -9)],
	"s_right": [Vector2(444, -9), Vector2(474, -9), Vector2(504, -9)],
	"ts_1": [Vector2(320, 55), Vector2(350, 55), Vector2(380, 55), Vector2(238, 110), Vector2(238, 140), Vector2(238, 170), Vector2(320, 180), Vector2(350, 180), Vector2(380, 180)],
	"ts_2": [Vector2(407, 55), Vector2(437, 55), Vector2(467, 55), Vector2(407, 180), Vector2(437, 180), Vector2(467, 180)],
	"ts_3": [Vector2(495, 55), Vector2(525, 55), Vector2(555, 55), Vector2(612, 108), Vector2(612, 138), Vector2(612, 144), Vector2(495, 180), Vector2(525, 180), Vector2(555, 180)],
	"f_1": [Vector2(653, 133), Vector2(653, 148), Vector2(653, 163)],
	"f_2": [Vector2(653, 185), Vector2(653, 200), Vector2(653, 215)],
	"t_1": [Vector2(653, 428), Vector2(653, 453), Vector2(653, 478)],
	"t_2": [Vector2(653, 494), Vector2(653, 519), Vector2(653, 544)],
	"bob": [Vector2(653, 21), Vector2(653, 46), Vector2(653, 71)],
	"o_1": [Vector2(292, 572)],
	"o_2": [Vector2(424, 572)],
	"o_3": [Vector2(558, 572)],
	"o_4": [Vector2(686, 572)]
}
#endregion

#region Declarations

@onready var cook_avatar = $Player
@onready var cmds_node = $CMDs
@onready var round_camera = $RoundCamera
@onready var camera_animation_player = $CameraAnimationPlayer
@onready var dd = $INTERACTABLES/DrinkDispenser
@onready var freezer = $INTERACTABLES/Freezer
#endregion

func _ready():
	print("Round node ready")
	start_camera_pan()

func _input(event):
	pass

func start_camera_pan():
	if round_camera and camera_animation_player:
		camera_animation_player.play("PanCamera")
	else:
		print("Camera and AnimationPlayer not found")


func _on_player_reached_interactable(target: Vector2):
	for key in coordinate_key.keys():
		if target in coordinate_key[key]:
			if key == "dd_left":
				dd_left.emit()
				break

