extends Area2D

@onready var game_manager: Node = %GameManager
@onready var player: CharacterBody2D = $"../../Player"

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
	game_manager.add_point()
	player.set_double_jump()
	queue_free()
