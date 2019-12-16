extends Control
onready var main_lang = $main_lang
onready var to_azure = $to_azure
var path = "res://finals_ogg/%s_final_01.ogg"
onready var audio_pl = get_node("AudioStreamPlayer")
onready var sounds = {}

func _ready():
#	print(AudioServer.get_device_list())
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