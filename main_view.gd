extends Camera2D

@export var pan_speed := 700
@export var min_zoom := 0.5
@export var max_zoom := 3.0
@export var zoom_step := 0.15

var dragging := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector(
		"camera_left",
		"camera_right",
		"camera_up",
		"camera_down",
	)
	
	position += delta * direction * pan_speed / zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			change_zoom(zoom_step)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			change_zoom(-zoom_step)
	
	if event is InputEventPanGesture:
		var scroll: float = event.delta.y
		change_zoom(-scroll * 0.05)
	
	if event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom.x

func change_zoom(amount: float) -> void:
	var new_zoom := clampf(
		zoom.x + amount,
		min_zoom,
		max_zoom
	)
	
	zoom = Vector2(new_zoom, new_zoom)
