extends Area2D
#drag and then select ctrl
@onready var timer: Timer = $Timer #path to nodee
@onready var player: CharacterBody2D = $"../Player"

#only drag
#$Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died!!!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	player.set_is_dead()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
