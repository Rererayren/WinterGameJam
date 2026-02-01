extends Area2D

@onready var game_manager: Node = %GameManager
@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	label.text = \
	"""..."""


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
