extends Node2D

enum MODE {BUILD, MINE}

var mode := MODE.MINE

@onready var rock_layer := $RockLayer
@onready var building_placement := $BuildingPlacement


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build_mode"):
		mode = MODE.BUILD
		update_mode()
		
	elif event.is_action_pressed("mine_mode"):
		mode = MODE.MINE
		update_mode()
	

func update_mode() -> void:
	building_placement.set_building_enabled(mode == MODE.BUILD)
	rock_layer.set_mining_enabled(mode == MODE.MINE)
