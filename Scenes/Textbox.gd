extends CanvasLayer

const CHAR_READ_RATE = 0.05
@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State{
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	hide_textbox()
	queue_text("This text is goisdvng to be added")
	queue_text("This text is goivsdvsdvdng to be added")
	queue_text("This text is govdsfsdving to be added")
	queue_text("This text is goidvsng to be added")
	
func _process(delta):
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("dialogue_next"):
				label.visible_characters = len(label.text)
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("dialogue_next"):
				if not text_queue.is_empty():
					change_state(State.READY)
				else:
					hide_textbox()  # Hide textbox if no more text

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("State.READY")
		State.READING:
			print("State.READING")
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
	start_symbol.text = " *"
	textbox_container.show()


func _on_tween_finished():
		end_symbol.text = "* "
		change_state(State.FINISHED)
		
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_characters = 0
	change_state(State.READING)
	show_textbox()
	var tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE)
