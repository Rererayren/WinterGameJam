extends Interactable

@onready var textbox_container: MarginContainer = $"TextboxContainer"
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

var player_in_area: bool = false

func _ready() -> void:
	super._ready()
	textbox_container.visible = false
	interacted.connect(_on_interacted)

func _on_interacted() -> void:
	textbox_container.visible = !textbox_container.visible
	if textbox_container.visible:
		label.text = message

func hide_propmt() -> void:
	textbox_container.visible = false
