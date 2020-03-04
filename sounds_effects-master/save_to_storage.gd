extends Reference
# var file_name = "settings/%s.json"
var file_name_all_lang = "settings.json"

signal error(text)
signal ok(text)

func _ready():
	pass 

func does_consist_upper_case(_str):
	var tmp_str = _str
	var to_low = tmp_str.to_lower()
	var res = false
	var i = int(0)
	while i < tmp_str.length():
		if tmp_str[i] != to_low[i]:
			res = true
		i += 1
	return res


func prepare_data(settings):
	print("try save settings")
	var i  = int(1)
	var soundef = {}
	while i < AudioServer.get_bus_count():
		var _name = AudioServer.get_bus_name(i)
		settings[_name] = {}
		var k = 0
		while k < AudioServer.get_bus_effect_count(i):
			if !AudioServer.is_bus_effect_enabled(i,k):
				k+=1
				continue
			var eff = AudioServer.get_bus_effect(i, k)
			soundef = {}
			var j = int(8)
			var soundef_name = eff.get_property_list()[7]["name"]
			while j  < (eff.get_property_list().size() - 2):
				var name_raw = eff.get_property_list()[j]["name"]
				if name_raw == "":
					j+=1
					continue
				if does_consist_upper_case(name_raw):
					if name_raw.find(soundef_name) >= 0:
						soundef_name = name_raw
					j+=1
					continue
				soundef[name_raw] = eff[name_raw]
				j+=1
			settings[_name][soundef_name] = soundef
			k+=1
		i+=1
	print("stop_cycle")
	return settings

func save_settings(settings, file_name):
	var full_name = file_name
	if file_name == "":
		emit_signal("error", "error, no file name")
		return
	var to_file = prepare_data(settings)
#	for lang in to_file:
#		var fd = File.new()
#		if fd.open(file_name % lang, File.WRITE) == OK:
#			fd.store_string(JSON.print(to_file[lang], "  "))
#			fd.close()

	var fd = File.new()
	if fd.open(file_name_all_lang, File.WRITE) == OK:
		fd.store_string(JSON.print(to_file, "  "))
		fd.close()
		emit_signal("ok", "saved as %s"%file_name)
	
	if fd.open(full_name, File.WRITE) == OK:
		fd.store_string(JSON.print(to_file, "  "))
		fd.close()
		emit_signal("ok", "saved as %s"%file_name)
#	var s1 = "ab/"
#	var s2 = "Ab/"
#	print(does_consist_upper_case(s1))
#	print(does_consist_upper_case(s2))
#	return
	
	

