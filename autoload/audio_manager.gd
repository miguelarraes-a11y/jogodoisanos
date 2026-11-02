extends Node
## Música e efeitos com volumes separados (barramentos "Music" e "SFX").
## Os arquivos ficam em assets/audio/<nome>.wav.
## Inclui suporte a desbloqueio de áudio web (WebAudio autoplay policy).

const AUDIO_DIR := "res://assets/audio/"

var _music: AudioStreamPlayer
var _current_music_name := ""
var _current_music_volume := -6.0
var _audio_unlocked := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_bus("Music")
	_ensure_bus("SFX")
	if OS.has_feature("web"):
		AudioServer.set("driver/output_latency", 50)


func _unhandled_input(event: InputEvent) -> void:
	if not _audio_unlocked:
		if event is InputEventMouseButton or event is InputEventScreenTouch or event is InputEventKey:
			if event.is_pressed():
				_unlock_audio()


func _unlock_audio() -> void:
	_audio_unlocked = true
	# Garante que nenhum barramento está mutado
	for i in AudioServer.bus_count:
		AudioServer.set_bus_mute(i, false)

	# Se estiver na web, chama o desbloqueador WebAudio do navegador
	if OS.has_feature("web"):
		var js := """
			if (window.__unlockAllAudio) {
				window.__unlockAllAudio();
			}
		"""
		JavaScriptBridge.eval(js)

	# Se a música deveria estar tocando mas foi suspensa ou interrompida, retoma
	if _music != null and is_instance_valid(_music) and not _music.playing:
		_music.play()


func _ensure_bus(bus_name: String) -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return
	AudioServer.add_bus()
	var i := AudioServer.bus_count - 1
	AudioServer.set_bus_name(i, bus_name)
	AudioServer.set_bus_send(i, "Master")


func _load_stream(sound_name: String) -> AudioStream:
	var path := AUDIO_DIR + sound_name + ".wav"
	if ResourceLoader.exists(path):
		return load(path)
	push_warning("Áudio ausente: " + path)
	return null


## Toca um efeito. Com loop=true repete até stop_player() ser chamado.
func play_sfx(sound_name: String, volume_db: float = 0.0, loop: bool = false) -> AudioStreamPlayer:
	var stream := _load_stream(sound_name)
	if stream == null:
		return null
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.bus = "SFX"
	p.volume_db = volume_db
	add_child(p)
	if loop:
		p.finished.connect(p.play)
	else:
		p.finished.connect(p.queue_free)
	p.play()
	return p


func stop_player(p: AudioStreamPlayer, fade: float = 0.5) -> void:
	if p == null or not is_instance_valid(p):
		return
	if p.finished.is_connected(p.play):
		p.finished.disconnect(p.play)
	if fade <= 0.0:
		p.queue_free()
		return
	var t := create_tween()
	t.tween_property(p, "volume_db", -60.0, fade)
	await t.finished
	if is_instance_valid(p):
		p.queue_free()


func play_music(sound_name: String, fade: float = 1.5, volume_db: float = -6.0) -> void:
	_current_music_name = sound_name
	_current_music_volume = volume_db
	stop_music(fade)
	var stream := _load_stream(sound_name)
	if stream == null:
		return
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.bus = "Music"
	# Evita silêncio absoluto (-60 dB) que pode congelar na web antes do tween
	if fade > 0.0:
		p.volume_db = volume_db - 12.0
	else:
		p.volume_db = volume_db
	add_child(p)
	p.finished.connect(p.play)
	p.play()
	if fade > 0.0:
		var t := create_tween()
		t.tween_property(p, "volume_db", volume_db, fade)
	_music = p


func stop_music(fade: float = 1.0) -> void:
	if _music != null:
		var old := _music
		_music = null
		stop_player(old, fade)


func set_music_volume(linear: float) -> void:
	var idx := AudioServer.get_bus_index("Music")
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(linear, 0.0001)))


func set_sfx_volume(linear: float) -> void:
	var idx := AudioServer.get_bus_index("SFX")
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(linear, 0.0001)))
