extends Control

onready var cells = $CenterContainer/GridContainer.get_children()
var last = 0
var better_board = {
	errors_size = 10000,
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
onready var regions = get_regions()
func _ready():
	randomize()
	create_board()
	yield(get_tree().create_timer(3),"timeout")
	fix_errors()

func create_board():
#	for region in regions:
#		for item in region.size():
#			region[item].text = str(item+1)
	var array = []
	for i in 5:
		for a in 5:
			array.append(a+1)
	for item in cells:
		var random = array[randi()% array.size()-1]
		item.text = str(random)
		array.erase(random)

func fix_errors():
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
	#Si las columnas tienen repetidos
	for column in columns:
		var values = []
		for i in column:
			values.append(cells[i])
		for a in values:
			for b in values:
				if  a != b and a.text == b.text and not errors.has(a):
					errors.append(a)
	#Si las regiones tienen repetidos
	for region in regions:
		for a in region:
			for b in region:
				if a != b and a.text == b.text and not errors.has(a):
					errors.append(a)
	if errors.size() == 0:
		return
	if better_board["errors_size"] > errors.size():
		better_board["board"] = cells.duplicate()
		better_board["errors_size"] = errors.size()
		better_board["errors"] = errors.duplicate()
		print(errors.size())
	elif last > 100:
		create_board()
		errors = []
		better_board["errors_size"] = 10000
		last = 0
	else:
		cells = better_board["board"].duplicate()
		errors = better_board["errors"].duplicate()
		last += 1
	shuffle_errors(errors)
	#shuffle_errors(errors)
	fix_errors()

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
