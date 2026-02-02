extends Area2D

@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	label.text = \
	"""Thank you for collecting all masks for us!
	Use your new action to go to the peak next to where Mask 2 was."""


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
