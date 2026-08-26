extends Node
## Global settings singleton (Autoload).
## Handles music/sfx volume and saves them between sessions.
## Volumes are stored as a 0.0-1.0 linear value and converted to
## decibels for the audio buses named "Music" and "SFX".
## NOTE: those two buses must exist in the Audio Bus layout
## (Audio panel at the bottom of the Godot editor). This project
## ships a default_bus_layout.tres that already defines them.

const SAVE_PATH := "user://settings.cfg"

var music_volume: float = 0.8
var sfx_volume: float = 0.8

func _ready() -> void:
	load_settings()
	apply_volumes()

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	apply_volumes()
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	apply_volumes()
	save_settings()

func apply_volumes() -> void:
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	# Treat 0 as fully muted instead of -80db math edge case.
	if linear_value <= 0.0:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(linear_value))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music_volume", music_volume)
	cfg.set_value("audio", "sfx_volume", sfx_volume)
	cfg.save(SAVE_PATH)

func load_settings() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err == OK:
		music_volume = cfg.get_value("audio", "music_volume", 0.8)
		sfx_volume = cfg.get_value("audio", "sfx_volume", 0.8)
