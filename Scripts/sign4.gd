extends Area2D

@onready var game_manager: Node = %GameManager
@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label
var checked : bool = false

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	
	if game_manager.get_point() < 3:
		label.text = \
		"""
		CHECKPOINT!
		
		...
		"""
	else:
		label.text = \
		"""
		CHECKPOINT!
		
		Thank you for collecting all masks!
		Go to the mound where Mask 2 was.
		"""
	
	# Checkpoint
	if body.name == "Player" and !checked:
		print("Checkpoint ", $RespawnPoint.global_position)
		game_manager.set_last_location($RespawnPoint.global_position)
		checked = true


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
