class_name CrudeCombustionGenerator
extends Area2D

signal selected(generator)

var fuel := 0


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit(self)
		get_viewport().set_input_as_handled()


func add_fuel(amount: int) -> void:
	fuel += 1
