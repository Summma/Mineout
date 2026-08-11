extends TileMapLayer

var tiles: Dictionary = {}
var mining := false
var mining_time := 0.0

@export var required_mining_time := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(-20, 21):
		for y in range(-20, 21):
			var dx := x + 0.5
			var dy := y + 0.5
			
			if dx*dx + dy*dy < 5 * 5:
				continue
				
			create_rock(Vector2i(x, y))


func _process(delta: float) -> void:
	if mining:
		var progress := mining_time / required_mining_time
		$mining_overlay.modulate.a = progress * 0.5
		
		var mouse_pos := get_global_mouse_position()
		var cell := local_to_map(to_local(mouse_pos))
		
		if progress >= 1.0:
			erase_rock(cell)
			$mining_overlay.visible = false
			mining = false
				
		mining_time += delta


func _unhandled_input(event: InputEvent) ->  void:
	if event is InputEventMouseButton:
		var mouse_pos := get_global_mouse_position()
		var cell := local_to_map(to_local(mouse_pos))
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if tiles.has(cell):
				mining = true
				mining_time = 0
				$mining_overlay.visible = true
				$mining_overlay.position = map_to_local(cell)
		
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mining = false
			$mining_overlay.visible = false


func create_rock(cell: Vector2i) -> void:
	set_cell(cell, 0, Vector2i(0, 0))
	tiles[cell] = 1


func erase_rock(cell: Vector2i) -> void:
	erase_cell(cell)
	tiles.erase(cell)
