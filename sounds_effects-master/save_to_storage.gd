extends Reference
var file_name = "settings.json"

func _ready():
	print("here")
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
	
func save_settings(settings):
	var to_file = prepare_data(settings)
	var fd = File.new()
	
	if fd.open(file_name, File.WRITE) == OK:
		fd.store_string(JSON.print(to_file, "  "))

		fd.close()
#	var s1 = "ab/"
#	var s2 = "Ab/"
#	print(does_consist_upper_case(s1))
#	print(does_consist_upper_case(s2))
#	return
	
	

