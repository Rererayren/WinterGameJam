extends CharacterBody2D

@onready var frame_anim: AnimationPlayer = $Sprite2D/frame_anim

const MAX_SPEED : float = 50.0
const JUMP_HEIGHT : float = -150.0
const SPRINT : float = MAX_SPEED * 2.0
const GRAVITY : float = 15
const ACCELERATION : float = 20.0
const FRICTION : float = 25.0
const DASH_SPEED : float = 200.0
const DASH_TIME : float = 0.10
const SUPER_DASH_SPEED : float = 300.0


var look_dir_x : int = 1
var can_dash : bool = true
var dash_timer : float = 0.0
#var super_dash_unlocked : bool = true
var super_dash_charger_timer : float = 0.0
var spawn_visual_timer : float = 0.0
const spawn_visual_interval_fash : float = 0.06
const spawn_visual_interval_super_dash : float = 0.025	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x : float = Input.get_axis("ui_left", "ui_right")
	if dash_timer == 0.0 and super_dash_charger_timer == 0.0:
		var velocity_weight_x : float = 1.0 - exp(- (ACCELERATION if dir_x else FRICTION) * delta)
		velocity.x = lerp(velocity.x, dir_x * MAX_SPEED, velocity_weight_x)

	if dir_x:
		look_dir_x = int(dir_x)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT
	velocity.y += GRAVITY

	if dir_x:
		velocity.x = dir_x * MAX_SPEED
		if Input.is_action_pressed("sprint"):
			velocity.x = dir_x * SPRINT
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)

	move_and_slide()
