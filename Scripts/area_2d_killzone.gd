extends Area2D
#drag and then select ctrl
@onready var timer: Timer = $Timer #path to nodee

#only drag
#$Timer

func _on_body_entered(body: Node2D) -> void:
	print("you died!!!")
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
