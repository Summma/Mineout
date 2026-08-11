class_name CommandCore
extends Area2D

var inventory: Dictionary = {
	"stone": 0,
	"coal": 0,
}

func _ready() -> void:
	update_inventory_ui()


func add_resource(resource: String, amount: int) -> void:
	assert(inventory.has(resource), "Unknown resource: " + resource)
	
	inventory[resource] += amount
	update_inventory_ui()


func remove_resource(resource: String, amount: int) -> bool:
	assert(inventory.has(resource), "Unknown resource: " + resource)
	
	if inventory[resource] < amount:
		return false
	
	inventory[resource] -= amount
	update_inventory_ui()
	
	return true


func update_inventory_ui() -> void:
	var label_text = ""
	
	for resource in inventory.keys():
		label_text += resource + ": " + str(inventory[resource]) + "\n"
	
	$"../UI/InventoryLabel".text = label_text
