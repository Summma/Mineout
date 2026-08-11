class_name CommandCore
extends Area2D

var inventory: Dictionary = {
	"stone": 0
}


func add_resource(resource: String, amount: int) -> void:
	assert(inventory.has(resource), "Unknown resource: " + resource)
	
	inventory[resource] += amount
	$"../UI/StoneLabel".text = "Stone: " + str(inventory[resource])


func remove_resource(resource: String, amount: int) -> bool:
	assert(inventory.has(resource), "Unknown resource: " + resource)
	
	if inventory[resource] < amount:
		return false
	
	inventory[resource] -= amount
	return true
