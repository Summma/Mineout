class_name CrudeCombustionGenerator
extends Area2D

signal selected(generator)

var fuel := 0
var fuel_timer: Timer

@export var fuel_consumption_time := 60


func _ready() -> void:
	fuel_timer = Timer.new()
	add_child(fuel_timer)
	
	fuel_timer.wait_time = fuel_consumption_time
	fuel_timer.one_shot = false
	
	fuel_timer.timeout.connect(fuel_tick)


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit(self)
		get_viewport().set_input_as_handled()


func add_fuel(amount: int) -> void:
	if fuel == 0:
		fuel_timer.start()
		
	fuel += amount

func fuel_tick() -> void:
	fuel -= 1
	$"../../UI/GeneratorPanel".update_panel()
	if fuel == 0:
		fuel_timer.stop()
