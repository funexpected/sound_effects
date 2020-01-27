extends Reference

var audio_pl = null
var sounds = null
signal stop_music
signal unpressed_btn
signal error(text)

func validate_name(file_name):
	var path = "res://voice_profiles/%s"
	var full_path =  path % file_name
	var fd = File.new()
	if fd.file_exists(full_path):
		return true
	else:
		return false

var compared_set = {}
func get_settings(file_name):
	var path = "res://voice_profiles/%s"
	var full_path =  path % file_name
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


func new_eff(ef_name, ef_settings):
	var ef
#	ef = AudioEffectPitchShift.new()
#	ef["pitch_scale"] = 1
#	return ef
	match ef_name:
		"AudioEffectAmplify" : ef = AudioEffectAmplify.new()
		"AudioEffectBandLimitFilter" : ef = AudioEffectBandLimitFilter.new()
		"AudioEffectBandPassFilter" : ef = AudioEffectBandPassFilter.new()
		"AudioEffectChorus" : ef = AudioEffectChorus.new()
		"AudioEffectCompressor" : ef = AudioEffectCompressor.new()
		"AudioEffectDelay": ef = AudioEffectDelay.new()
		"AudioEffectDistortion": ef = AudioEffectDistortion.new()
		"AudioEffectEQ": ef = AudioEffectEQ.new()
		"AudioEffectEQ10" : ef = AudioEffectEQ10.new()
		"AudioEffectEQ21" : ef = AudioEffectEQ21.new()
		"AudioEffectEQ6" : ef = AudioEffectEQ6.new()
		"AudioEffectFilter" : ef = AudioEffectFilter.new()
		"AudioEffectHighPassFilter" : ef = AudioEffectHighPassFilter.new()
		"AudioEffectHighShelfFilter" : ef = AudioEffectHighShelfFilter.new()
		"AudioEffectLimiter" : ef = AudioEffectLimiter.new()
		"AudioEffectLowPassFilter" : ef = AudioEffectLowPassFilter.new()
		"AudioEffectLowShelfFilter" : ef = AudioEffectLowShelfFilter.new()
		"AudioEffectNotchFilter" : ef = AudioEffectNotchFilter.new()
		"AudioEffectPanner" :  ef = AudioEffectPanner.new()
		"AudioEffectPhaser" : ef = AudioEffectPhaser.new()
		"AudioEffectPitchShift" : ef = AudioEffectPitchShift.new()
		"AudioEffectRecord" : ef = AudioEffectRecord.new()
		"AudioEffectReverb" : ef = AudioEffectReverb.new()
		"AudioEffectSpectrumAnalyzer" : ef = AudioEffectSpectrumAnalyzer.new()
		"AudioEffectStereoEnhance" : ef = AudioEffectStereoEnhance.new()
		_: ef = null
	if ef:	
		for param in ef_settings:
			ef[param] = ef_settings[param]
	return ef

func remove_all_effects(our_bus):
	for b in range(AudioServer.get_bus_effect_count(our_bus) - 1, -1, -1):
		AudioServer.remove_bus_effect(our_bus, b)

func create_bus(settings, lang):
	if settings == null:
		return
	var our_bus = AudioServer.get_bus_index("custom")
	var nb_ef =  AudioServer.get_bus_effect_count(our_bus) 
	if  AudioServer.get_bus_effect_count(our_bus) > 0:
		remove_all_effects(our_bus)
	for ef in settings:
		AudioServer.add_bus_effect(our_bus, new_eff(ef, settings[ef]), -1)
		
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
	create_bus(compared_set, ln)
	audio_pl.bus = "custom"
	audio_pl.play()

