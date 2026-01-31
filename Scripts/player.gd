extends CharacterBody2D

const MAX_SPEED: float = 64.5
const SPRINT: float = MAX_SPEED * 2.0
const JUMP_HEIGHT: float = -165.0
const MAX_JUMP_TRIES: int = 2
const GRAVITY: float = 9.81
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5
const MAX_STAMINA: float = 100.0
const STAMINA_REGEN: float = 5.0

var look_dir_x: int = 1

var jump_count: int = 0

const DASH_SPEED: float = 200.0
const DASH_TIME: float = 0.12
var dash_unlocked: bool = true
var can_dash: bool = true
var dash_timer: float = 0.0

const SUPER_DASH_SPEED: float = 300.0
const SUPER_DASH_TIME: float = 0.2
const SUPER_DASH_COST: float = 20.0
var stamina = MAX_STAMINA
var super_dash_unlocked: bool = true
var can_super_dash: bool = true
var is_super_dashing: bool = false
var super_dash_timer: float = 0.2
var super_dash_charge_cost: float = 0.5
var super_dash_charge_timer: float = 0.0

const SUPER_DASH_HOLD_TIME: float = 0.35
var dash_hold_time: float = 0.0
var suppres_dash: bool = false

func _physics_process(delta: float) -> void:
	var dir_x: float = Input.get_axis("ui_left", "ui_right")
	if dash_timer == 0.0 and super_dash_charge_timer == 0.0:
		var velocity_weight_x: float = 1.0 - exp(-(ACCELERATION if dir_x else FRICTION) * delta)
		velocity.x = lerp(velocity.x, dir_x * MAX_SPEED, velocity_weight_x)
		_sprint_logic(delta, dir_x)
	
		if dir_x:
			look_dir_x = int(dir_x)
	
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_HEIGHT
		_double_jump_logic(delta)
		velocity.y += GRAVITY
	
	_regen_stamina(delta)
	_handle_dash_joypad_priority(delta)
	if dash_unlocked:
		_dash_logic(delta)
	if super_dash_unlocked:
		_super_dash_logic(delta)
	
	if is_on_floor():
		if dash_timer == 0.0 and !can_dash:
			can_dash = true
		if dash_timer == 0.0 and not is_super_dashing and !can_super_dash:
			can_super_dash = true
	
	move_and_slide()

func _sprint_logic(delta: float, direction: float) -> void:
	if Input.is_action_pressed("sprint"):
		velocity.x = SPRINT * direction

func _double_jump_logic(delta: float) -> void:
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump"):
		jump_count += 1
		if jump_count <= MAX_JUMP_TRIES:
			velocity.y = JUMP_HEIGHT
	
func _dash_logic(delta: float) -> void:
	if can_dash and Input.is_action_just_pressed("dash") and not suppres_dash:
		can_dash = false
		dash_timer = DASH_TIME
		velocity.x = DASH_SPEED * look_dir_x
		velocity.y = 0
	
	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
		if is_on_wall():
			dash_timer = 0.0
	
func _super_dash_logic(delta: float) -> void:
	if stamina < SUPER_DASH_COST:
		super_dash_charge_cost = 0.0
		return
	
	if can_super_dash and stamina >= SUPER_DASH_COST and is_on_floor() and not is_super_dashing:
		if Input.is_action_pressed("super_dash") and suppres_dash:
			velocity = Vector2.ZERO
			super_dash_charge_timer += delta
			if super_dash_charge_timer >= super_dash_charge_cost:
				stamina -= SUPER_DASH_COST
				can_super_dash = false
				is_super_dashing = true
				super_dash_timer = SUPER_DASH_TIME
				velocity.x = SUPER_DASH_SPEED * look_dir_x
				velocity.y = 0.0
		else:
			super_dash_charge_timer = 0.0
	
	if is_super_dashing:
		super_dash_timer -= delta
		if is_on_wall() or super_dash_timer <= 0.0:
			is_super_dashing = false
			super_dash_timer = 0.0
			super_dash_charge_timer = 0.0

func _handle_dash_joypad_priority(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		dash_hold_time = 0.0
		suppres_dash = false
	
	if Input.is_action_pressed("dash"):
		dash_hold_time += delta
		if dash_hold_time >= SUPER_DASH_HOLD_TIME:
			suppres_dash = true
	
	if Input.is_action_just_released("dash"):
		dash_hold_time = 0.0
		suppres_dash = false

func _regen_stamina(delta: float) -> void:
	if stamina < MAX_STAMINA:
		stamina += STAMINA_REGEN * delta
		stamina = min(stamina, MAX_STAMINA)
		print(stamina)
