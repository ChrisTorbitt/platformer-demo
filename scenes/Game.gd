extends Node2D

@export var fall_death_y: float = 400.0

@onready var player: CharacterBody2D = $Player
var _spawn_position: Vector2

func _ready() -> void:
	_spawn_position = player.global_position

func _process(_delta: float) -> void:
	if player.global_position.y > fall_death_y:
		_respawn()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _respawn() -> void:
	player.global_position = _spawn_position
	player.velocity = Vector2.ZERO
