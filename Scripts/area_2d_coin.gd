extends Area2D

@onready var game_manager: Node = %GameManager
@onready var player: CharacterBody2D = $"../../Player"
@onready var textbox_container: MarginContainer = $"../../Ability Textboxes/TextboxContainer"
@onready var label: Label = $"../../Ability Textboxes/TextboxContainer/MarginContainer/HBoxContainer/Label"
@onready var textbox_container_2: MarginContainer = $"../../Ability Textboxes/TextboxContainer2"
@onready var label2: Label = $"../../Ability Textboxes/TextboxContainer2/MarginContainer/HBoxContainer/Label"
#@onready var textbox_container_3: MarginContainer = $"../../Ability Textboxes/TextboxContainer3"
#@onready var label3: Label = $"../../Ability Textboxes/TextboxContainer3/MarginContainer/HBoxContainer/Label"

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("debug coin")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body: Node2D) -> void:
	print('+1 mask')
	var masks_collected: int = game_manager.add_point()
	if masks_collected >= 1:
		player.set_double_jump()
		textbox_container.visible = true
		label.text = "You've unlocked Double Jump (Jump twice)!"
	if masks_collected >= 2:
		player.set_super_dash()
		textbox_container_2.visible = true
		label2.text = "You've unlocked Super Dash (Keyboard S or Joypad B)!"
	if masks_collected >= 3:
		player.set_float()
		#textbox_container_3.visible = true
		#label3.text = "You've unlocked Slow Falling (Double Jump then hold)!"
	queue_free()
