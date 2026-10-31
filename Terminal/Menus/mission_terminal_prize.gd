extends TextureRect

@onready var item_sprite:Sprite2D = $Sprite2D
@onready var amount = $LabelAmount
@onready var credit_sprite = preload("res://Icons/Credit_Single.png")
@onready var key_sprite = preload("res://Icons/Credit_Single.png")

func Do_Prize(type, item_amount, item_id):
	match type:
		#units
		0:
			Do_Unit_Icon(item_id)
			amount.hide()
		#credits
		1:
			item_sprite.texture = credit_sprite
			amount.text = str(int(item_amount))
		#boss loot
		2:
			pass

func Do_Unit_Icon(id):
	var t
	var obj

	obj = SPAWNER._spawn([id], null, Vector2(0,0), Vector2(0,0), 0, 0,0)

	t = ICONS._get_icon(obj.name_text)
	if t != null:
		item_sprite.texture = t
	
	#remove the dummy from the game
	obj.dead = true
