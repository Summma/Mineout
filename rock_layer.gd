extends TileMapLayer

var tiles: Dictionary = {}
var mining := false
var mining_time := 0.0
var mining_cell := Vector2i.ZERO

@export var required_mining_time := 2.0
@export var control_radius := 8.0

@onready var command_core: CommandCore = $"../CommandCore"

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
		mining_time += delta
		var progress := mining_time / required_mining_time
		$MiningOverlay.modulate.a = progress * 0.5
		
		if progress >= 1.0:
			erase_rock(mining_cell)
			command_core.add_resource("stone", 1)
			$MiningOverlay.visible = false
			mining = false


func _unhandled_input(event: InputEvent) ->  void:
	if event is InputEventMouseButton:
		var mouse_pos := get_global_mouse_position()
		var cell := local_to_map(to_local(mouse_pos))
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var dcx := cell.x + 0.5
			var dcy := cell.y + 0.5
			if tiles.has(cell) and dcx ** 2 + dcy ** 2 < control_radius ** 2:
				mining = true
				mining_time = 0
				mining_cell = cell
				$MiningOverlay.visible = true
				$MiningOverlay.position = map_to_local(cell)
				$MiningOverlay.modulate.a = 0.0
				
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mining = false
			$MiningOverlay.visible = false


func create_rock(cell: Vector2i) -> void:
	set_cell(cell, 0, Vector2i(0, 0))
	tiles[cell] = 1


func erase_rock(cell: Vector2i) -> void:
	erase_cell(cell)
	tiles.erase(cell)
