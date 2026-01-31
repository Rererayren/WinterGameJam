extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	READY,
	FINISHED
}
var current_state = State.READY
var text_queue = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	#hide_textbox()
	queue_text("This text is going to be added")
	queue_text("2")
	queue_text("3")
	queue_text("4")
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("State.READY")
		State.FINISHED:
			print("State.FINISHED")
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func queue_text(next_text):
	text_queue.push_back(next_text)
	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	show_textbox()
