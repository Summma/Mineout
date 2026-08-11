extends TileMapLayer

const TILE_DATA = {
	"stone": {
		"source_id": 0,
		"atlas_coords": Vector2i(0, 0),
	},
	"coal": {
		"source_id": 1,
		"atlas_coords": Vector2i(0, 0),
	}
}

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
				
			var mat_chance = randf()
			
			if mat_chance < 0.12:
				create_rock(Vector2i(x, y), "coal")
			else:
				create_rock(Vector2i(x, y), "stone")


func _process(delta: float) -> void:
	if mining:
		mining_time += delta
		var progress := mining_time / required_mining_time
		$MiningOverlay.modulate.a = progress * 0.5
		
		if progress >= 1.0:
			command_core.add_resource(tiles[mining_cell], 1)
			erase_rock(mining_cell)
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


func create_rock(cell: Vector2i, material: String) -> void:
	assert(TILE_DATA.has(material), material + " doesn't exist.")
	
	var data = TILE_DATA[material]
	
	set_cell(cell, data["source_id"], data["atlas_coords"])
	tiles[cell] = material


func erase_rock(cell: Vector2i) -> void:
	erase_cell(cell)
	tiles.erase(cell)
