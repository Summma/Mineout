extends Node2D


class Generators:
	var items: Array[CrudeCombustionGenerator] = []


class Cells:
	var items: Array[Vector2i] = []


var generator_grid: Dictionary[Vector2i, Generators] = {}
var generator_cells: Dictionary[CrudeCombustionGenerator, Cells]= {}


func get_available_power(cell: Vector2i) -> int:
	var out := 0
	for generator in generator_grid.get(cell, Generators.new()).items:
		out += generator.get_available_power()
	
	return out


func add_generator(cell: Vector2i, generator: CrudeCombustionGenerator) -> void:
	if !generator_grid.has(cell):
		generator_grid[cell] = Generators.new()
	
	if !generator_cells.has(generator):
		generator_cells[generator] = Cells.new()
	
	generator_grid[cell].items.append(generator)
	generator_cells[generator].items.append(cell)


func remove_generator(generator: CrudeCombustionGenerator) -> void:
	for cell in generator_cells[generator].items:
		generator_grid[cell].items.erase(generator)
		
		if generator_grid[cell].items.is_empty():
			generator_grid.erase(cell)
	
	generator_cells.erase(generator)
