extends Area2D

@onready var game_manager: Node = %GameManager
@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if game_manager.get_point() >= 3:
		textbox_container.visible = true
		label.text = \
		"""Thank you, Leaf for finding our masks!
		You made it to the end of your journey.
		The forest balance has been restored"""
