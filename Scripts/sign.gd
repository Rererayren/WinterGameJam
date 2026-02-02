extends Area2D

@onready var game_manager: Node = %GameManager
@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _on_body_entered(body: Node2D) -> void:
	textbox_container.visible = true
	label.text = \
	"""- Movement (Keyboard A/D or Joypad L)
- Jump (Keyboard Space or Joypad A)
- Sprint (Keyboard Shift or Joypad LS)
- Dash (Keyboard C or Joypad X)

Collect MASKS to unlocked more actions:
- Double Jump (Jump twice)
- Super Dash (Keyboard S or Joypad B)
- Slow Falling (Double Jump then Jump Hold)"""


func _on_body_exited(body: Node2D) -> void:
	textbox_container.visible = false
