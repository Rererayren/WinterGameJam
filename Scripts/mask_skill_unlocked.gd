extends Area2D

@onready var game_manager: Node = %GameManager
@onready var player: CharacterBody2D = $"../../Player"
@onready var textbox_container: MarginContainer = $"../../Ability Textboxes/TextboxContainer"
@onready var label: Label = $"../../Ability Textboxes/TextboxContainer/MarginContainer/HBoxContainer/Label"
@onready var textbox_container_2: MarginContainer = $"../../Ability Textboxes/TextboxContainer2"
@onready var label2: Label = $"../../Ability Textboxes/TextboxContainer2/MarginContainer/HBoxContainer/Label"
@onready var textbox_container_3: MarginContainer = $"../../Ability Textboxes/TextboxContainer3"
@onready var label3: Label = $"../../Ability Textboxes/TextboxContainer3/MarginContainer/HBoxContainer/Label"
@onready var timer_double_jump: Timer = $"../../Ability Textboxes/TextboxContainer/DoubleJumpTextboxTimer"
@onready var timer_super_dash: Timer = $"../../Ability Textboxes/TextboxContainer2/SuperDashTextboxTimer"
@onready var timer_float: Timer = $"../../Ability Textboxes/TextboxContainer3/FloatTextboxTimer"
@onready var animated_sprite_2d_2: AnimatedSprite2D = $"../Area2D Coin2/AnimatedSprite2D"
@onready var animated_sprite_2d_3: AnimatedSprite2D = $"../Area2D Coin3/AnimatedSprite2D"

enum SkillMessageType {
	DOUBLE_JUMP,
	SUPER_DASH,
	FLOAT,
}

var current_textbox: Control = null
var current_label: Label = null

func _ready() -> void:
	timer_double_jump.timeout.connect(_on_timer_timeout)
	timer_super_dash.timeout.connect(_on_timer2_timeout)
	timer_float.timeout.connect(_on_timer3_timeout)
	textbox_container.visible = false
	textbox_container_2.visible = false
	textbox_container_3.visible = false
	animated_sprite_2d_2.play("Meloncholy")
	animated_sprite_2d_3.play("Wistful")
	
func show_timed_message(type: SkillMessageType, message: String, duration: float) -> void:
	match type:
		SkillMessageType.DOUBLE_JUMP:
			current_textbox = textbox_container
			textbox_container.visible = true
			label.text = message
			timer_double_jump.wait_time = duration
			timer_double_jump.start()
		SkillMessageType.SUPER_DASH:
			current_textbox = textbox_container_2
			textbox_container_2.visible = true
			label2.text = message
			timer_super_dash.wait_time = duration
			timer_super_dash.start()
		SkillMessageType.FLOAT:
			current_textbox = textbox_container_3
			textbox_container_3.visible = true
			label3.text = message
			timer_float.wait_time = duration
			timer_float.start();
	
func _on_timer_timeout() -> void:
	if current_textbox:
		current_textbox.visible = false
	
func _on_timer2_timeout() -> void:
	textbox_container_2.visible = false
	
func _on_timer3_timeout() -> void:
	textbox_container_3.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	print('+1 mask')
	var masks_collected: int = game_manager.add_point()
	if masks_collected == 1:
		player.set_double_jump()
		show_timed_message(SkillMessageType.DOUBLE_JUMP, "You've unlocked Double Jump (Jump twice)!", 10.0)
	if masks_collected == 2:
		player.set_super_dash()
		show_timed_message(SkillMessageType.SUPER_DASH, "You've unlocked Super Dash (Keyboard S or Joypad B)!", 10.0)
	if masks_collected == 3:
		player.set_float()
		show_timed_message(SkillMessageType.FLOAT, "You've unlocked Slow Falling (Double Jump + Jump Hold)!", 10.0)
	$CollisionShape2D.set_deferred("disabled", true)
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.visible = false
