extends Node

@onready var player: CharacterBody2D = $"../Player"

var checkpoint_id : int = 0
var last_location : Vector2
var mask_collected : int = 0


func get_last_location() -> Vector2:
	return last_location

func set_last_location(location: Vector2) -> void:
	last_location = location

func get_point() -> int:
	return mask_collected

func add_point() -> int:
	mask_collected += 1
	print("Total masks: ", mask_collected)
	return mask_collected

func update_checkpoint_id() -> void:
	checkpoint_id += 1
	print("New checkpoints!")
