extends PanelContainer

signal building_selected(building_data)

const BUILDINGS_PATH := "res://data/buildings/"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_menu()


func open() -> void:
	visible = true
	position = Vector2(
		0,
		get_viewport_rect().size.y - size.y - 20
	)


func populate_menu() -> void:
	var dir = DirAccess.open(BUILDINGS_PATH)
	
	if dir == null:
		push_error("Could not open BUILDINGS_PATH")
		return
	
	dir.list_dir_begin()
	
	var file_name := dir.get_next()
	
	while file_name != "":
		var resource := load(BUILDINGS_PATH + file_name)
		add_building_button(resource)
		file_name = dir.get_next()
	
	dir.list_dir_end()


func add_building_button(building_data: BuildingData) -> void:
	var button := Button.new()
	
	button.text = building_data.display_name
	button.icon = building_data.icon
	
	button.pressed.connect(
		_on_building_button_pressed.bind(building_data)
	)

	$VBoxContainer.add_child(button)


func _on_building_button_pressed(building_data: BuildingData) -> void:
	building_selected.emit(building_data)
