extends TileMapLayer

var tiles: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(-20, 21):
		for y in range(-20, 21):
			if x*x + y*y < 5 * 5:
				continue
			set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			tiles[Vector2i(x, y)] = 1


func _unhandled_input(event: InputEvent) ->  void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos := get_global_mouse_position()
			var cell := local_to_map(to_local(mouse_pos))
			
			if tiles.has(cell):
				erase_cell(cell)
				tiles.erase(cell)
