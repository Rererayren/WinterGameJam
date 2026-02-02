extends Area2D

@onready var game_manager: Node = %GameManager
@onready var timer: Timer = $Timer #path to nodee
@onready var player: CharacterBody2D = $"../Player"


func _on_body_entered(body: Node2D) -> void:
	print("You died!!!")
	Engine.time_scale = 0.5
	#body.get_node("CollisionShape2D").queue_free()
	player.set_is_dead()
	timer.start()


#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1
	#get_tree().reload_current_scene()
	
	
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	killPlayer()


func killPlayer() -> void:
	print(game_manager.get_last_location())
	if game_manager.get_last_location() == Vector2(0.0, 0.0):
		get_tree().reload_current_scene()
	player.position = game_manager.get_last_location()
	player.unset_is_dead()
