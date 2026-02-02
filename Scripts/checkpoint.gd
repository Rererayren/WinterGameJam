extends Area2D

@onready var game_manager: Node = %GameManager
var checked : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !checked:
		print("Checkpoint ", $RespawnPoint.global_position)
		game_manager.set_last_location($RespawnPoint.global_position)
		checked = true
