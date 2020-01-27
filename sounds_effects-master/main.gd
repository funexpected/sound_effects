extends Control
onready var main_lang = $main_net/set/google/main_lang
onready var to_azure = $main_net/set/azure/to_azure
var path = "res://finals_ogg/%s_final_01.ogg"
onready var audio_pl = get_node("AudioStreamPlayer")
onready var sounds = {}
onready var save = get_node("main_net/save/save")
onready var compare = $compare/compare/compare
onready var compare_buttons = $compare/set


enum STATE{DEFAULT, CUSTOM}
var state = STATE.DEFAULT
onready var main_lang_c = $compare/set/google/main_lang
onready var to_azure_c = $compare/set/azure/to_azure

onready var Storage = preload("res://save_to_storage.gd").new()
onready var Compare = preload("res://compare.gd").new()
onready var save_as = $main_net/save/save_as
onready var error_save = $main_net/save/error

onready var error_fields = {"save": $main_net/save/error, "compare" : $compare/compare/error}

var settings  = {
}
#{
#	"en" : 
#		{
#			"soundef_1" : 
#				{
#					"par_1" : 0,
#					"par_2" :0,
#				},
#			"soundef_2" :
#				{ 
#					"par_1" : 0,
#					"par_2" :0,
#				},
#		}
#}
func _ready():
	set_buses()
	compare_buttons.visible = false
	save.connect("pressed", self, "save_settings")
	Storage.connect("error", self, "error", [error_fields["save"]])
	compare.connect("pressed", self, "get_compare")
	Compare.connect("stop_music", self, "stop_music")
	Compare.connect("unpressed_btn", self, "unpressed_btn")
	Compare.connect("error", self, "error", [error_fields["compare"]]);
	Storage.connect("ok", self, "ok")
	for el in main_lang.get_children():
		el.text = el.name
		sounds[el.name] = load(path % el.name)
		el.connect("button_down", self, "play_sound", [el.name, el,])
	for k in to_azure.get_children():
		k.text = k.name
		sounds[k.name] = load(path % k.name)
		k.connect("button_down", self, "play_sound", [k.name, k])
		
	get_node("AudioStreamPlayer").play()

func save_settings():
	Storage.save_settings(settings, save_as.text)

func ok(text):
	var ok = $main_net/save/ok
	ok.text = text
	ok.show()
	yield(wait(2), "completed")
	ok.hide()
	
	
func error(text, er):
	print("here")
	er.show()
	er.text = text
	yield(wait(1), "completed")
	er.hide()
func get_compare():
	if compare.pressed:
		$compare/compare/file_name.readonly = true
		var file_name = get_node("compare/compare/file_name").text
		init_compare(file_name)
		for el in main_lang_c.get_children():
			el.text = el.name
			el.connect("button_down", Compare, "play_sound", [el.name, el])
		for k in to_azure_c.get_children():
			k.text = k.name
			k.connect("button_down", Compare, "play_sound", [k.name, k])
		compare_buttons.visible = true
	if !compare.pressed:
		$compare/compare/error.hide()
		$compare/compare/file_name.readonly = false
		compare_buttons.visible = false

func init_compare(file_name):
	Compare.audio_pl = audio_pl
	Compare.sounds = sounds
	Compare.get_settings(file_name)
	
func set_buses():
	#0 is master bus
	var i = int(1)
	var bus_example = AudioServer.get_bus_index("en")
	var example_effect = AudioServer.get_bus_effect(bus_example, 2).duplicate()
	var buses = AudioServer.get_bus_count()-1
	
	while i < buses:
		var _name = AudioServer.get_bus_name(i)
		if _name != 'en':
			var nb = AudioServer.get_bus_effect_count(i)
			var k = 0
			while k < nb:
				var eff = AudioServer.get_bus_effect(i, k)
				if eff.get_property_list()[7]["name"] == example_effect.get_property_list()[7]["name"]:
#					print("I already have reverb effect")
					break
				k += 1
			if k == nb:
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
		

func wait(time):
	yield(get_tree().create_timer(time), "timeout")

func play_sound(ln, btn):
#	print("btn_status")
#	print(btn.pressed)
	if btn.pressed == true:
#		print("pressed")
		stop_music()
#		yield(wait(0.5), "completed")
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
	yield(wait(0.5), "completed")

func unpressed_btn():
	for k in main_lang.get_children():
		if k.pressed == true:
			k.pressed = false
	for el in to_azure.get_children():
		if el.pressed == true:
			el.pressed = false
	for l in main_lang_c.get_children():
		if l.pressed == true:
			l.pressed = false
	for n in to_azure_c.get_children():
		if n.pressed == true:
			n.pressed = false
	
			

#{
#	"en" : 
#		{
#			"soundef_1" : 
#				{
#					"par_1" : 0,
#					"par_2" :0,
#				},
#			"soundef_2" :
#				{ 
#					"par_1" : 0,
#					"par_2" :0,
#				},
#		}
#}





	
	