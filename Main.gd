extends Control

onready var cells = $CenterContainer/GridContainer.get_children()
onready var regions = get_regions()

var better_board = {
	errors = [],
	board = []
}
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
	var last_errs = check_errors()
	var errs = check_errors()
	while errs.size() != 0:
		#print(errs.size())
		shuffle_errors(errs)
		errs = check_errors()
#		if last_errs.size() < errs.size():
#			randomize_board()
#	var array = []
#	for i in 5:
#		for a in 5:
#			array.append(a+1)
#	for item in cells:
#		var random = array[randi()% array.size()-1]
#		item.text = str(random)
#		array.erase(random)

func randomize_board():
	for region in regions:
		var nums = [1,2,3,4,5]
		nums.shuffle()
		for item in region.size():
			if not better_board["errors"].has(region[item]):
				region[item].text = str(nums.pop_front())
			else:
				nums.erase(int(region[item].text))

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
