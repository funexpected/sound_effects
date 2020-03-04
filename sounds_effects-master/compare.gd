extends Reference

var audio_pl = null
var sounds = null
signal stop_music
signal unpressed_btn
signal error(text)

var compared_set = {}
func get_settings(file_name):
	var full_path =  file_name
	var fd = File.new()
	if !fd.file_exists(full_path):
		emit_signal("error","Could not read settings file!")
		return null
	if fd.open(full_path, File.READ) == OK:
		var parsed_dictionary = JSON.parse(fd.get_as_text()).result
		compared_set = parsed_dictionary
		fd.close()
#		create_bus(parsed_dictionary[setting_for_locale])
		return true

func play_sound(ln, btn):
	if btn.pressed == true:
		emit_signal("stop_music")
#		stop_music()
#		yield(wait(0.5), "completed")
	else:
		if audio_pl.is_playing() == true:
			emit_signal("unpressed_btn")
			emit_signal("stop_music")
		play_music(ln)

func play_music(ln):
	audio_pl.stream = sounds[ln]
	Sound.create_bus(compared_set, ln)
	audio_pl.bus = "custom"
	audio_pl.play()

