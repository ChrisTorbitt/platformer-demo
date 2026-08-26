extends CharacterBody2D

@export var speed: float = 160.0
@export var jump_velocity: float = -320.0
@export var gravity: float = 900.0
@export var max_fall_speed: float = 500.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _has_double_jump: bool = true
var _facing: int = 1

@onready var sprite: ColorRect = $Sprite
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_input(delta)
	_handle_jump_buffer(delta)
	move_and_slide()
	_handle_stomps()
	_update_facing()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	else:
		_coyote_timer = coyote_time
		_has_double_jump = true

	if _coyote_timer > 0.0:
		_coyote_timer -= delta

func _handle_input(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	if direction != 0:
		_facing = sign(direction)

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

func _handle_jump_buffer(delta: float) -> void:
	if _jump_buffer_timer > 0.0:
		_jump_buffer_timer -= delta
		var can_ground_jump := is_on_floor() or _coyote_timer > 0.0
		if can_ground_jump:
			_do_jump()
			_jump_buffer_timer = 0.0
		elif _has_double_jump:
			_do_jump()
			_has_double_jump = false
			_jump_buffer_timer = 0.0

func _do_jump() -> void:
	velocity.y = jump_velocity
	_coyote_timer = 0.0
	SFX.play_beep(sfx_player, 660.0, 0.10, "square")

func _handle_stomps() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider and collider.is_in_group("enemy"):
			# Stomped from above.
			if collision.get_normal().y < -0.5:
				if collider.has_method("stomp"):
					collider.stomp()
				velocity.y = jump_velocity * 0.6
				SFX.play_beep(sfx_player, 990.0, 0.08, "sine")

func _update_facing() -> void:
	sprite.scale.x = abs(sprite.scale.x) * _facing if _facing != 0 else sprite.scale.x
