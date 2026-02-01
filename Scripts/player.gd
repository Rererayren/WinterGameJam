extends CharacterBody2D

enum STATE {
	FALL,
	FLOOR,
	JUMP,
	DOUBLE_JUMP,
	FLOAT,
	DASH,
	SUPER_DASH,
}

const MAX_SPEED: float = 64.5
const SPRINT: float = MAX_SPEED * 2.0
const JUMP_HEIGHT: float = -160.0
const MAX_JUMP_TRIES: int = 2
const GRAVITY: float = 9.81
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5

const MAX_STAMINA: float = 100.0
const STAMINA_REGEN: float = 5.0

const FLOAT_GRAVITY: float = 200.0
const FLOAT_VELOCITY: float = 100.0

const DASH_COOLDOWN: float = 2.0
const DASH_SPEED: float = 200.0
const DASH_TIME: float = 0.12

const SUPER_DASH_SPEED: float = 250.0
const SUPER_DASH_TIME: float = 0.4
const SUPER_DASH_COST: float = 20.0

var active_state: STATE = STATE.FALL
var look_dir_x: int = 1
var jump_count: int = 0
var stamina: float = MAX_STAMINA

@onready var float_cooldown: Timer = $FloatCooldown
@onready var game_manager: Node = %GameManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var can_dash: bool = true
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var just_dashed: bool = false

var super_dash_unlocked: bool = false
var can_super_dash: bool = true
var super_dash_timer: float = 0.2

var double_jump_unlocked: bool = false
var float_unlocked: bool = false
var is_dead: bool = false

func _ready() -> void:
	switch_state(active_state)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "dash":
		print("The Dash animation has finished!")
		just_dashed = false

func _physics_process(delta: float) -> void:
	process_state(delta)
	_update_timers(delta)
	#print(jump_count)
	move_and_slide()

func switch_state(current_state: STATE) -> void:
	var previous_state: STATE = active_state
	active_state = current_state
	print(just_dashed)
	
	match active_state:
		STATE.FALL:
			print("FALL!!!")
		STATE.FLOOR:
			print("FLOOR")
			jump_count = 0
			if not can_super_dash and super_dash_unlocked:
				can_super_dash = true
		STATE.JUMP:
			print("JUMP")
			velocity.y = JUMP_HEIGHT
			jump_count = 1
		STATE.DOUBLE_JUMP:
			print("DOUBLE JUMP")
			velocity.y = JUMP_HEIGHT
			jump_count = 2
		STATE.FLOAT:
			print("FLOAT")
			if float_cooldown.time_left > 0:
				active_state = previous_state
				return
			velocity.y = 0
		STATE.DASH:
			print("DASH")
			just_dashed = true
			can_dash = false
			dash_timer = DASH_TIME
			dash_cooldown_timer = DASH_COOLDOWN
			velocity.x = DASH_SPEED * look_dir_x
			velocity.y = 0
		STATE.SUPER_DASH:
			print("SUPER DASH")
			stamina -= SUPER_DASH_COST
			just_dashed = true
			can_super_dash = false
			super_dash_timer = SUPER_DASH_TIME
			velocity.x = SUPER_DASH_SPEED * look_dir_x
			velocity.y = 0.0

func process_state(delta: float) -> void:
	match active_state:
		STATE.FALL:
			velocity.y += GRAVITY
			_movement_logic(delta)
			
			if is_on_floor():
				switch_state(STATE.FLOOR)
			elif Input.is_action_just_pressed("jump"):
				if jump_count == 0:
					switch_state(STATE.JUMP)
				elif jump_count < MAX_JUMP_TRIES and double_jump_unlocked:
					switch_state(STATE.DOUBLE_JUMP)
				elif float_unlocked:
					switch_state(STATE.FLOAT)
			elif try_super_dash():
				pass
			elif try_dash():
				pass
		STATE.FLOOR:
			_movement_logic(delta)
			if not is_on_floor():
				switch_state(STATE.FALL)
			elif Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP)
			elif try_super_dash():
				pass
			elif try_dash():
				pass
		STATE.JUMP, STATE.DOUBLE_JUMP:
			velocity.y += GRAVITY
			_movement_logic(delta)
			
			if velocity.y >= 0:
				switch_state(STATE.FALL)
			elif Input.is_action_just_pressed("jump") and jump_count < MAX_JUMP_TRIES and double_jump_unlocked:
				switch_state(STATE.DOUBLE_JUMP)
			elif try_super_dash():
				pass
			elif try_dash():
				pass
		STATE.FLOAT:
			velocity.y = move_toward(velocity.y, FLOAT_VELOCITY, FLOAT_GRAVITY * delta)
			_movement_logic(delta)
			
			if is_on_floor():
				switch_state(STATE.FLOOR)
			elif Input.is_action_just_pressed("jump"):
				float_cooldown.start()
				switch_state(STATE.FALL)
			elif try_super_dash():
				pass
			elif try_dash():
				pass
		STATE.DASH:
			dash_timer -= delta
			
			if is_on_wall() or dash_timer <= 0.0:
				dash_timer = 0.0
				switch_state(STATE.FALL if not is_on_floor() else STATE.FLOOR)
		STATE.SUPER_DASH:
			super_dash_timer -= delta
			
			if is_on_wall() or super_dash_timer <= 0.0:
				super_dash_timer = 0.0
				switch_state(STATE.FALL if not is_on_floor() else STATE.FLOOR)

func _movement_logic(delta: float) -> void:
	var dir_x: float = Input.get_axis("ui_left", "ui_right")
	_play_animation(delta, dir_x, just_dashed)
	
	if dir_x:
		look_dir_x = int(dir_x)
	
	var target_speed: float = MAX_SPEED
	if Input.is_action_pressed("sprint") and dir_x:
		target_speed = SPRINT
	
	var weight: float = ACCELERATION if dir_x else FRICTION
	var velocity_weight_x: float = 1.0 - exp(-weight * delta)
	velocity.x = lerp(velocity.x, dir_x * target_speed, velocity_weight_x)

func _play_animation(delta: float, direction: float, just_dashed: bool) -> void:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if !is_dead:
		if (just_dashed):
			if animated_sprite_2d.animation != "dash":
				animated_sprite_2d.play("dash")
		elif is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")
	elif animated_sprite_2d.animation != "death":
		animated_sprite_2d.play("death")

func try_dash() -> bool:
	if not can_dash:
		return false
	if dash_cooldown_timer > 0.0:
		return false
	if not Input.is_action_just_pressed("dash"):
		return false
	
	switch_state(STATE.DASH)
	return true
	
func try_super_dash() -> bool:
	if not super_dash_unlocked:
		return false
	if not can_super_dash:
		return false	
	if stamina < SUPER_DASH_COST:
		return false
	if not Input.is_action_pressed("super_dash"):
		return false
		
	switch_state(STATE.SUPER_DASH)
	return true

func _update_timers(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer = max(0.0, dash_cooldown_timer - delta)
	if dash_cooldown_timer == 0.0 and not can_dash:
		can_dash = true
	
	_regen_stamina(delta)

func _regen_stamina(delta: float) -> void:
	if stamina < MAX_STAMINA:
		stamina += STAMINA_REGEN * delta
		stamina = min(stamina, MAX_STAMINA)

func set_double_jump():
	double_jump_unlocked = true

func set_super_dash():
	super_dash_unlocked = true

func set_float():
	float_unlocked = true

func set_is_dead():
	is_dead = true
