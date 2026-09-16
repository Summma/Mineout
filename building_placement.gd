extends Node2D

var can_build := false
var occupied_cells: Dictionary = {}
var selected_building = null
var active_panel = null
var selected_building_data: BuildingData

const COMMAND_CORE_CELLS := [
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(0, 0),
]

@onready var rock_layer := $"../RockLayer"
@onready var overlay := $"../Buildings/BuildingOverlay"
@onready var build_menu := $"../UI/BuildMenu"


func _ready() -> void:
	build_menu.building_selected.connect(_on_building_menu_selected)
	

func _process(delta: float) -> void:
	if can_build and selected_building_data and selected_building_data.scene != null:
		var mouse_pos = get_global_mouse_position()
		var cell_pos = rock_layer.local_to_map(rock_layer.to_local(mouse_pos))
		var snapped_pos = rock_layer.to_global(rock_layer.map_to_local(cell_pos))
		
		overlay.global_position = snapped_pos
		if cell_is_empty(cell_pos):
			overlay.modulate = Color(1, 1, 1, 0.5)
		else:
			overlay.modulate = Color(1, 0.3, 0.3, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and can_build \
	and selected_building_data \
	and selected_building_data.scene != null:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			var cell_pos = rock_layer.local_to_map(rock_layer.to_local(mouse_pos))
			
			if cell_is_empty(cell_pos):
				place_building(cell_pos)


func _on_building_menu_selected(building_data):
	selected_building_data = building_data
	overlay.texture = building_data.icon


func place_building(cell: Vector2i) -> void:
	if selected_building_data == null or selected_building_data.scene == null:
		return
	
	if not $"../CommandCore".remove_resources(selected_building_data.cost):
		return
	
	var building = selected_building_data.scene.instantiate()
	building.grid_cell = cell
	building.building_data = selected_building_data
	
	$"../Buildings".add_child(building)
	
	building.global_position = rock_layer.to_global(
		rock_layer.map_to_local(cell)
	)
	occupied_cells[cell] = building
	
	building.selected.connect(_on_building_selected)


func _on_building_selected(building):
	deselect_building()
	
	selected_building = building
	
	var panel_scene = selected_building.get_panel()
	active_panel = panel_scene.instantiate()
	active_panel.building = selected_building
	$"../UI".add_child(active_panel)
	active_panel.open(selected_building)


func deselect_building() -> void:
	selected_building = null

	if active_panel != null:
		active_panel.queue_free()
		active_panel = null


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
		build_menu.open()
	else:
		overlay.visible = false
		
		overlay.texture = null
		selected_building_data = null
		
		build_menu.visible = false
