extends Label

var price = 0

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	_get_price()

func _get_price():
	var m = get_parent()
	var ig = m.get_node("Menu_Items/ItemGrid")
	price = round(GLOBAL.sell_rate * ig._calc_price())
	text = str(price)
	return price
