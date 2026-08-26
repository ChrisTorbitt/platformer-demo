class_name SFX
extends RefCounted
## Tiny procedural sound generator so this demo has working SFX
## without needing any external audio files.
## Usage: SFX.play_beep(audio_stream_player, 880.0, 0.12)
## Swap this out later for real .ogg/.wav files if you want -
## just change AudioStreamPlayer.stream to a loaded sound.

static func play_beep(player: AudioStreamPlayer, freq_hz: float, duration_sec: float, wave: String = "square") -> void:
	var mix_rate := 44100.0
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = mix_rate
	generator.buffer_length = duration_sec + 0.05
	player.stream = generator
	player.play()

	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	if playback == null:
		return

	var total_frames := int(mix_rate * duration_sec)
	var phase := 0.0
	var increment := freq_hz / mix_rate

	for i in range(total_frames):
		var sample := 0.0
		match wave:
			"square":
				sample = 1.0 if sin(phase * TAU) >= 0.0 else -1.0
			"sine":
				sample = sin(phase * TAU)
			_:
				sample = sin(phase * TAU)
		# Simple fade out to avoid clicking at the end.
		var fade := 1.0 - float(i) / float(max(total_frames, 1))
		sample *= 0.25 * fade
		phase = fmod(phase + increment, 1.0)
		playback.push_frame(Vector2(sample, sample))
