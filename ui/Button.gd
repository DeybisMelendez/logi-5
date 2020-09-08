tool
extends Button
enum Colors{red, blue, yellow, fucsia, green}
export (Colors) var color setget _set_color

func _set_color(col):
	var style = get("custom_styles/normal").duplicate()
	match col:
		0:
			style.bg_color = Color("FF0000")
		1:
			style.bg_color = Color("0000FF")
		2:
			style.bg_color = Color("FFFF00")
		3:
			style.bg_color = Color("FF00FF")
		4:
			style.bg_color = Color("00FF00")
	color = col
	set("custom_styles/normal", style)
	set("custom_styles/hover", style)
	set("custom_styles/pressed", style)
