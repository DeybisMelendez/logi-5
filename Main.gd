extends Control

onready var cells = $CenterContainer/GridContainer.get_children()
onready var regions = get_regions()

var stack = []
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
	randomize()
	randomize_board()
	create_board()
#	yield(get_tree().create_timer(3),"timeout")
#	fix_errors()

func create_board():
	var errors = check_errors()
	while errors.size() != 0:
		print(errors.size())
		var size = errors.size()
		shuffle(errors)
		var nerrors = check_errors()
		while size < nerrors.size():
			shuffle(errors)
			nerrors = check_errors()
		if check_errors().size() < size:
			stack.append(get_configuration())
		elif stack.size() > 0:
			var conf = stack.pop_back()
			set_configuration(conf)
		else:
			randomize_board()
		errors = check_errors()
		#yield(get_tree().create_timer(0.1),"timeout")

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
#					errors.append(b)
	return errors

func shuffle_errors(errors):
	#print(errors.size())
	var temp_errors = errors.duplicate()
	var shuffle = []
	for i in temp_errors:
		shuffle.append(i.text)
	var first_item = shuffle.pop_front()
	shuffle.append(first_item)
	for i in errors.size():
		var random = shuffle[randi()% shuffle.size()]
		errors[i].text = random
		shuffle.erase(random)

func get_regions():
	var regions = [[],[],[],[],[]]
	for cell in cells:
		regions[cell.color].append(cell)
	return regions

#CREAR CASILLAS():
#	Asignar aleatoriamente 5 veces números del 1 al 5 en cada casilla.
#
#ARREGLAR ERRORES(Casillas):
#	crear array Errores
#	Por cada fila de las Casillas:
#		si hay números repetidos en la fila:
#			agregar casillas repetidas al Array Errores
#	Por cada columna de las Casillas:
#		si hay números repetidos en al columna:
#			agregar casillas repetidas al Array Errores
#	Por cada region de las Casillas:
#		si hay números repetidos en la región:
#			agregar casillas repetidas al Array Errores
#	si el tamaño de Array Errores es cero:
#		devolver Casillas
#	Eliminar casillas repetidas de Array Errores
#	Duplicar Array Errores a Array Casillas Mezclar
#	Por cada item de Array Errores:
#		Elegir aleatoriamente una casilla de Array Casillas Mezclar.
#		Eliminar casilla obtenida de Array Casillas Mezclar.
#		Asignar número de la casilla elegida a Casillas en la posición de item de Array Errores.
#	devolver ARREGLAR ERRORES(Casillas)
#
#Casillas Random = CREAR CASILLAS()
#Resultado = ARREGLAR ERRORES(Casillas Random)
