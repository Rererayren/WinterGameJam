extends Area2D

@onready var game_manager: Node = %GameManager
@onready var player: CharacterBody2D = $"../../Player"
@onready var textbox_container: MarginContainer = $"../../Ability Textboxes/TextboxContainer"
@onready var label: Label = $"../../Ability Textboxes/TextboxContainer/MarginContainer/HBoxContainer/Label"
@onready var textbox_container_2: MarginContainer = $"../../Ability Textboxes/TextboxContainer2"
@onready var label2: Label = $"../../Ability Textboxes/TextboxContainer2/MarginContainer/HBoxContainer/Label"
@onready var textbox_container_3: MarginContainer = $"../../Ability Textboxes/TextboxContainer3"
@onready var label3: Label = $"../../Ability Textboxes/TextboxContainer3/MarginContainer/HBoxContainer/Label"
@onready var timer: Timer = $"../../Ability Textboxes/TextboxContainer/DisplayTextboxTimer"
@onready var animated_sprite_2d_2: AnimatedSprite2D = $"../Area2D Coin2/AnimatedSprite2D"
@onready var animated_sprite_2d_3: AnimatedSprite2D = $"../Area2D Coin3/AnimatedSprite2D"

enum SkillMessageType {
	DOUBLE_JUMP,
	SUPER_DASH,
	SLOW_FALLING,
}

var current_textbox: Control = null
var current_label: Label = null

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	textbox_container.visible = false
	textbox_container_2.visible = false
	textbox_container_3.visible = false
	animated_sprite_2d_2.play("Meloncholy")
	animated_sprite_2d_3.play("Wistful")
	
func show_timed_message(type: SkillMessageType, message: String, duration: float = 1.0) -> void:
	if current_textbox:
		current_textbox.visible = false
	match type:
		SkillMessageType.DOUBLE_JUMP:
			current_textbox = textbox_container
			current_label = label
		SkillMessageType.SUPER_DASH:
			current_textbox = textbox_container_2
			current_label = label2
	
	current_textbox.visible = true
	current_label.text = message
	timer.wait_time = duration
	timer.start()
	
func _on_timer_timeout() -> void:
	if current_textbox:
		current_textbox.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	print('+1 mask')
	var masks_collected: int = game_manager.add_point()
	if masks_collected >= 1:
		player.set_double_jump()
		show_timed_message(SkillMessageType.DOUBLE_JUMP, "You've unlocked Double Jump (Jump twice)!", 1.0)
		#textbox_container.visible = true
		#label.text = "You've unlocked Double Jump (Jump twice)!"
	if masks_collected >= 2:
		player.set_super_dash()
		show_timed_message(SkillMessageType.SUPER_DASH, "You've unlocked Super Dash (Keyboard S or Joypad B)!", 1.0)
		#textbox_container_2.visible = true
		#label2.text = "You've unlocked Super Dash (Keyboard S or Joypad B)!"
	if masks_collected >= 3:
		player.set_float()
		show_timed_message(SkillMessageType.SLOW_FALLING, "You've unlocked Slow Falling (Double Jump then hold)!", 1.0)
		#textbox_container_3.visible = true
		#label3.text = "You've unlocked Slow Falling (Double Jump then hold)!"
	queue_free()
