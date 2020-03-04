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

onready var block = $"block"
onready var save_file = $save_file
onready var open_file = $open_file

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
	var save_file_close_buttons = [save_file.get_close_button(), save_file.get_cancel()]
	var open_file_close_buttons = [open_file.get_close_button(), open_file.get_cancel()] 
	Sound.set_buses()
	compare_buttons.visible = false
	save.connect("pressed", self, "save_settings")
	compare.connect("pressed", self, "get_compare")
	
	Storage.connect("error", self, "error", [error_fields["save"]])
	
	Compare.connect("stop_music", self, "stop_music")
	Compare.connect("unpressed_btn", self, "unpressed_btn")
	Compare.connect("error", self, "error", [error_fields["compare"]]);
	Storage.connect("ok", self, "ok")
	
	open_file.connect("file_selected", self, "init_compare")
	save_file.connect("file_selected", self, "init_save")
	
	for b in save_file_close_buttons:
		b.connect("pressed", self, "hide_block", [save])
	for b in open_file_close_buttons:
		b.connect("pressed", self, "hide_block", [compare])
	
	for el in main_lang.get_children():
		el.text = el.name
		sounds[el.name] = load(path % el.name)
		el.connect("button_down", self, "play_sound", [el.name, el,])
	for k in to_azure.get_children():
		k.text = k.name
		sounds[k.name] = load(path % k.name)
		k.connect("button_down", self, "play_sound", [k.name, k])
	get_node("AudioStreamPlayer").play()

func hide_block(who_emit):
	block.hide()
	who_emit.pressed = false

func save_settings():
	block.show()
	save_file.show()

func init_save(file_name):
	Storage.save_settings(settings, file_name)
	block.hide()
	save.pressed = false

func get_compare():
	if compare.pressed:
		block.show()
		open_file.show()
	if !compare.pressed:
		block.hide()
		compare_buttons.visible = false

func init_compare(file_name):
	Compare.audio_pl = audio_pl
	Compare.sounds = sounds
	Compare.get_settings(file_name)
	for el in main_lang_c.get_children():
			el.text = el.name
			el.connect("button_down", Compare, "play_sound", [el.name, el])
	for k in to_azure_c.get_children():
		k.text = k.name
		k.connect("button_down", Compare, "play_sound", [k.name, k])
	compare_buttons.visible = true
	block.hide()

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

func wait(time):
	yield(get_tree().create_timer(time), "timeout")

func play_sound(ln, btn):
	if btn.pressed == true:
		stop_music()
	else:
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
