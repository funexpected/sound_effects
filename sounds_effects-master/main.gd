extends Control
onready var main_lang = $main_lang
onready var to_azure = $to_azure
var path = "res://finals_ogg/%s_final_01.ogg"
onready var audio_pl = get_node("AudioStreamPlayer")
onready var sounds = {}

func _ready():
#	print(AudioServer.get_bus_count())
#	print(AudioServer.get_device_list())
#	print(AudioServer.get_bus_index("en"))
##	print(typeof(AudioServer.get_bus_effect(AudioServer.get_bus_index("en"), 0)))
#	print(AudioServer.get_bus_effect(AudioServer.get_bus_index("en"), 0))
#	print(AudioServer.get_bus_effect(AudioServer.get_bus_index("fr"), 0).get_property_list()[7])
#	print(AudioServer.get_bus_effect(AudioServer.get_bus_index("en"), 2).get_property_list()[7])
#	if AudioServer.get_bus_effect(AudioServer.get_bus_index("en"), 0) == AudioServer.get_bus_effect(AudioServer.get_bus_index("fr"), 0):
#		print("the same")
#	else:
#		print("not")
	set_buses()
	for el in main_lang.get_children():
		el.text = el.name
		sounds[el.name] = load(path % el.name)
		el.connect("button_down", self, "play_sound", [el.name, el])
	for k in to_azure.get_children():
		k.text = k.name
		sounds[k.name] = load(path % k.name)
		k.connect("button_down", self, "play_sound", [k.name, k])
	get_node("AudioStreamPlayer").play()
	pass 

func set_buses():
	#0 is master bus
	var i = int(1)
	var bus_example = AudioServer.get_bus_index("en")
	var example_effect = AudioServer.get_bus_effect(bus_example, 2).duplicate()
	var buses = AudioServer.get_bus_count()
	
	while i < buses:
		var name = AudioServer.get_bus_name(i)
		if name != 'en':
			var nb = AudioServer.get_bus_effect_count(i)
			var k = 0
			while k < nb:
				var eff = AudioServer.get_bus_effect(i, k)
				if eff.get_property_list()[7]["name"] == example_effect.get_property_list()[7]["name"]:
					print("I already have reverb effect")
					break
				k += 1
			if k == nb:
				AudioServer.add_bus_effect(i, example_effect.duplicate(), k)
				print("add effect to bus ", AudioServer.get_bus_name(i))
		i += 1
	check_added_sounds()
	
func check_added_sounds():
	var i = int(1)
	while i < AudioServer.get_bus_count():
		var name =  AudioServer.get_bus_name(i)
		var nb = AudioServer.get_bus_effect_count(i)
		var l = int(0)
		print(name)
		while l < AudioServer.get_bus_effect_count(i):
			print(AudioServer.get_bus_effect(i, l))
			l+=1
		i += 1
		

func wait(time):
	yield(get_tree().create_timer(time), "timeout")

func play_sound(ln, btn):
#	print("btn_status")
#	print(btn.pressed)
	if btn.pressed == true:
#		print("pressed")
		stop_music()
		yield(wait(0.5), "completed")
	else:
#		print("else")
		if audio_pl.is_playing() == true:
			unpressed_btn()
			stop_music()
		play_music(ln)


func play_music(ln):
	audio_pl.stream = sounds[ln]
	audio_pl.bus = ln
	audio_pl.play()

func stop_music():
	if audio_pl.is_playing() == true:
		audio_pl.playing = false

func unpressed_btn():
	for k in main_lang.get_children():
		if k.pressed == true:
			k.pressed = false
	for el in to_azure.get_children():
		if el.pressed == true:
			el.pressed = false