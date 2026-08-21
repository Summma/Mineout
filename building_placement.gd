extends Node2D

var can_build := false
var occupied_cells: Dictionary = {}

const CRUDE_GENERATOR_BUILDING = preload("res://crude_combustion_generator.tscn")
const COMMAND_CORE_CELLS := [
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(0, 0),
]

@onready var rock_layer := $"../RockLayer"
@onready var overlay := $"../Buildings/CrudeGeneratorOverlay"


func _process(delta: float) -> void:
	if can_build:
		var mouse_pos = get_global_mouse_position()
		var cell_pos = rock_layer.local_to_map(rock_layer.to_local(mouse_pos))
		var snapped_pos = rock_layer.to_global(rock_layer.map_to_local(cell_pos))
		
		overlay.global_position = snapped_pos
		if cell_is_empty(cell_pos):
			overlay.modulate = Color(1, 1, 1, 0.5)
		else:
			overlay.modulate = Color(1, 0.3, 0.3, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and can_build:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			var cell_pos = rock_layer.local_to_map(rock_layer.to_local(mouse_pos))
			
			if cell_is_empty(cell_pos):
				place_crude_generator(cell_pos)


func place_crude_generator(cell: Vector2i) -> void:
	if not $"../CommandCore".remove_resource("stone", 10):
		return
	
	var generator := CRUDE_GENERATOR_BUILDING.instantiate()
	$"../Buildings".add_child(generator)
	
	generator.global_position = rock_layer.to_global(
		rock_layer.map_to_local(cell)
	)
	occupied_cells[cell] = generator


func cell_is_empty(cell: Vector2i) -> bool:
	if rock_layer.tiles.has(cell):
		return false
	
	if occupied_cells.has(cell):
		return false
	
	if cell in COMMAND_CORE_CELLS:
		return false
	
	return true


func set_building_enabled(build: bool) -> void:
	can_build = build
	
	if can_build:
		overlay.visible = true
	else:
		overlay.visible = false
