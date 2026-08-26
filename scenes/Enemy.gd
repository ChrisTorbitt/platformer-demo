extends CharacterBody2D

@export var speed: float = 40.0
@export var patrol_distance: float = 48.0

var _start_x: float = 0.0
var _direction: int = 1

func _ready() -> void:
	_start_x = global_position.x
	add_to_group("enemy")

func _physics_process(_delta: float) -> void:
	velocity.x = speed * _direction
	velocity.y += 900.0 * get_physics_process_delta_time()
	move_and_slide()

	if global_position.x > _start_x + patrol_distance:
		_direction = -1
	elif global_position.x < _start_x - patrol_distance:
		_direction = 1

func stomp() -> void:
	queue_free()
