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
	
	Controls:
	- Movement (Keyboard A/D, Xbox L, or Sony/PS L)
	- Jump (Keyboard Space, Xbox A, or Sony/PS Cross)
	- Sprint (Keyboard Shift, Xbox LS, or Sony/PS L3)
	- Dash (Keyboard C, Xbox X, or Sony/PS Square)

	Collect MASKS to unlocked more actions:
	- MASK 1: Double Jump (Jump twice)
	- MASK 2: Super Dash (Keyboard S, Xbox B, or Sony/PS Circle)
	- MASK 3: Slow Falling (Jump three times)
	"""
	
	# Checkpoint
	if body.name == "Player" and !checked:
		print("Checkpoint ", $RespawnPoint.global_position)
		game_manager.set_last_location($RespawnPoint.global_position)
		checked = true


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
