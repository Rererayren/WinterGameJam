extends Area2D

@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	label.text = \
	"""Keep going!
	Please help us to collect 2 more Masks.
	We are waiting for you at the end of the journey!"""


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
