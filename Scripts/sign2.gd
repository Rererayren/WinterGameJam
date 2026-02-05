extends Area2D

@onready var game_manager: Node = %GameManager
@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label
var checked : bool = false

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	label.text = \
	"""
	CHECKPOINT!
	
	Keep going!
	Please help us to collect """ + str(3 - game_manager.get_point()) + """ more Masks.
	We are waiting for you at the end of the journey!
	"""
	
	# Checkpoint
	if body.name == "Player" and !checked:
		print("Checkpoint ", $RespawnPoint.global_position)
		game_manager.set_last_location($RespawnPoint.global_position)
		checked = true


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
