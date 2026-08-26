extends Control

@onready var music_slider: HSlider = $CenterContainer/VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $CenterContainer/VBoxContainer/SFXSlider
@onready var sfx_preview_player: AudioStreamPlayer = $SFXPreviewPlayer

func _ready() -> void:
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

func _on_music_slider_value_changed(value: float) -> void:
	GameSettings.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	GameSettings.set_sfx_volume(value)
	SFX.play_beep(sfx_preview_player, 500.0, 0.08, "square")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
