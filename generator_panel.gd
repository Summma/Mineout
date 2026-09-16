extends PanelContainer

var selected_generator: CrudeCombustionGenerator

@onready var command_core = $"../../CommandCore"


func _ready() -> void:
	$VBoxContainer/AddFuelButton.pressed.connect(_on_add_fuel_pressed)


func _on_add_fuel_pressed() -> void:
	if selected_generator == null:
		return

	if command_core.remove_resource("coal", 1):
		selected_generator.add_fuel(1)
		update_panel()


func open(generator: CrudeCombustionGenerator) -> void:
	selected_generator = generator
	visible = true
	
	position = Vector2(
		get_viewport_rect().size.x - size.x - 200,
		20
	)
	
	update_panel()


func close() -> void:
	selected_generator = null
	visible = false


func update_panel() -> void:
	if selected_generator == null:
		return

	$VBoxContainer/FuelLabel.text = "Fuel: " + str(selected_generator.fuel)
	$VBoxContainer/NameLabel.text = selected_generator.building_data.display_name
