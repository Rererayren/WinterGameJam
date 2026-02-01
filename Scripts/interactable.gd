extends Area2D
class_name Interactable

signal interacted


@export var prompt_text: String = "Press E to open sign"
@export_multiline var message: String = "Placeholder"

var player_near_object = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_near_object and Input.is_action_just_pressed("interact"):
		interact()

func _on_body_entered(body: Node2D) -> void:
	player_near_object = true
	show_prompt()

func _on_body_exited(body: Node2D) -> void:
	player_near_object = false
	hide_propmt()

func interact() -> void:
	interacted.emit()

func show_prompt() -> void:
	pass

func hide_propmt() -> void:
	pass
