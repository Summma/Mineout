class_name CrudeCombustionGenerator
extends Area2D

signal selected(generator)

var fuel := 0
var fuel_timer: Timer
var fuel_consumption_time := 2
var power_rate := 6
var effective_power_output := 0
var power_demand := 0
var grid_cell: Vector2i
var building_data: BuildingData

const NEIGHBOR_DIRS = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
]

@onready var power_network := $"../../PowerNetwork"


func _ready() -> void:
	fuel_timer = Timer.new()
	add_child(fuel_timer)
	
	fuel_timer.wait_time = fuel_consumption_time
	fuel_timer.one_shot = false
	
	fuel_timer.timeout.connect(fuel_tick)
	
	for neighbor_dir in NEIGHBOR_DIRS:
		power_network.add_generator(grid_cell + neighbor_dir, self)


func _exit_tree() -> void:
	power_network.remove_generator(self)


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit(self)
		get_viewport().set_input_as_handled()


func get_available_power() -> int:
	return effective_power_output - power_demand


func get_panel() -> PackedScene:
	return preload("res://UI/panels/generator_panel.tscn")


func add_fuel(amount: int) -> void:
	if fuel == 0:
		effective_power_output = power_rate
		fuel_timer.start()
		
	fuel += amount

func fuel_tick() -> void:
	fuel -= 1
	if $"../../BuildingPlacement".selected_building == self:
		$"../../BuildingPlacement".active_panel.update_panel()
	if fuel == 0:
		effective_power_output = 0
		fuel_timer.stop()
