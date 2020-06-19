extends Control

func _ready():
	pass

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

#in bus custom prepare sound effects as in setting_file
func create_bus(settings, lang):
	if !settings:
		return
	var our_bus = AudioServer.get_bus_index("custom")
	var nb_ef =  AudioServer.get_bus_effect_count(our_bus) 
	if  AudioServer.get_bus_effect_count(our_bus) > 0:
		remove_all_effects(our_bus)
	for ef in settings[lang]:
		print("ef->", ef)
		AudioServer.add_bus_effect(our_bus, new_eff(ef, settings[lang][ef]), -1)

#add button for duplicate reverb
#in busses make duplicate reverberation from en bus if bus does not have own reverb. If bus has reverb, system uses its reverb.
func set_buses():
	#0 is master bus
	var i = int(1)
	var example_effect = null
	var bus_example = AudioServer.get_bus_index("en")
	var pr = AudioServer.is_bus_effect_enabled(bus_example, 2)
	print("enabled", pr)
	if  AudioServer.is_bus_effect_enabled(bus_example, 2):
		example_effect = AudioServer.get_bus_effect(bus_example, 2).duplicate()
	var buses = AudioServer.get_bus_count()-1
	
	while i < buses:
		var _name = AudioServer.get_bus_name(i)
		if _name != 'en':
			var nb = AudioServer.get_bus_effect_count(i)
			var k = 0
			while k < nb:
				var eff = AudioServer.get_bus_effect(i, k)
				if example_effect && eff.get_property_list()[7]["name"] == example_effect.get_property_list()[7]["name"]:
#					print("I already have reverb effect")
					break
				k += 1
			if k == nb && example_effect:
				AudioServer.add_bus_effect(i, example_effect.duplicate(), k)
#				print("add effect to bus ", AudioServer.get_bus_name(i))
		i += 1
	check_added_sounds()
	
func check_added_sounds():
	var i = int(1)
	while i < AudioServer.get_bus_count() - 1:
		var _name =  AudioServer.get_bus_name(i)
		var nb = AudioServer.get_bus_effect_count(i)
		var l = int(0)
		print(_name)
		while l < AudioServer.get_bus_effect_count(i):
			print(AudioServer.get_bus_effect(i, l))
			l+=1
		i += 1
	
