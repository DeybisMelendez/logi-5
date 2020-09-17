extends Control

onready var cells = $VBoxContainer/CenterContainer/GridContainer.get_children()
onready var regions = get_regions()

var stack = []
var solution = []
var game = []
var rows = [
	[0,1,2,3,4],
	[5,6,7,8,9],
	[10,11,12,13,14],
	[15,16,17,18,19],
	[20,21,22,23,24]
]
var columns = [
	[0,5,10,15,20],
	[1,6,11,16,21],
	[2,7,12,17,22],
	[3,8,13,18,23],
	[4,9,14,19,24]
]
func _ready():
	$VBoxContainer/New.connect("button_up", self, "new_game")
	$VBoxContainer/Solution.connect("button_up",self, "solution")
	$VBoxContainer/Validate.connect("button_up", self, "validate")
	randomize()
	new_game()

func new_game():
	randomize_board()
	create_board()
	conf_board()

func validate():
	var errors = check_errors()
	if errors.size() > 0:
		OS.alert("Cantidad de errores: "+ str(errors.size()), "Su solución tiene errores")
	else:
		OS.alert("Resolviste el puzzle!", "Felicidades!")

func solution():
	set_configuration(solution)

func conf_board():
	solution = get_configuration()
	for cell in cells:
		cell.text = ""
	var regs = regions.duplicate()
	regs.shuffle()
	var random = regs[0][randi()% regs.size()]
	var id = int(random.name)
	random.text = solution[id]
	random.locked = true
	regs.pop_back()
	for region in regs:
		random = region[randi()% region.size()]
		id = int(random.name)
		random.text = solution[id]
		random.locked = true
	game = get_configuration()

func create_board():
	var errors = check_errors()
	while errors.size() != 0:
		print("errors: ",errors.size(),"	stack: ", stack.size())
		var size = errors.size()
		shuffle(errors)
		var nerrors = check_errors()
		while nerrors.size() > size:
			shuffle(errors)
			nerrors = check_errors()
		if nerrors.size() < size:
			stack.append(get_configuration())
		elif stack.size() > 0:
			var conf = stack.pop_back()
			set_configuration(conf)
		else:
			randomize_board()
		errors = check_errors()

func set_configuration(conf):
	for i in conf.size():
		cells[i].text = conf[i]

func get_configuration():
	var conf = []
	for item in cells:
		conf.append(item.text)
	return conf

func randomize_board():
	for region in regions:
		var nums = [1,2,3,4,5]
		nums.shuffle()
		for item in region:
			item.text = str(nums.pop_back())

func shuffle(errors):
	var r = []
	for i in errors:
		r.append(i.text)
	errors.shuffle()
	for i in errors:
		i.text = r.pop_back()

func check_errors():
	var errors = []
	#Si las filas tienen repetidos
	for row in rows:
		var values = []
		for i in row:
			values.append(cells[i])
		for a in values:
			for b in values:
				if  a != b and a.text == b.text and not errors.has(a):
					errors.append(a)
					#errors.append(b)
	#Si las columnas tienen repetidos
	for column in columns:
		var values = []
		for i in column:
			values.append(cells[i])
		for a in values:
			for b in values:
				if  a != b and a.text == b.text and not errors.has(a):
					errors.append(a)
					#errors.append(b)
	#Si las regiones tienen repetidos
	for region in regions:
		for a in region:
			for b in region:
				if a != b and a.text == b.text and not errors.has(a):
					errors.append(a)
					#errors.append(b)
	return errors

func get_regions():
	var regions = [[],[],[],[],[]]
	for cell in cells:
		regions[cell.color].append(cell)
	return regions
