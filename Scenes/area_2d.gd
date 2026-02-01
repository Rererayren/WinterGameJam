extends Area2D

@onready var textbox_container: MarginContainer = $"TextboxContainer2"
@onready var label: Label = $TextboxContainer2/MarginContainer/HBoxContainer/Label

func _on_body_entered(body: Node2D) -> void:
	print("Check")
	textbox_container.visible = true
	label.text = \
	"""Thank you!
	You made it to the end of the journey."""
	\
	

#func _on_body_exited(body: Node2D) -> void:
	#textbox_container.visible = false
