extends Sprite2D

@onready var star = preload("res://Background/StarA.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _gen_stars():
	var wide = GLOBAL.resx
	var high = GLOBAL.resy
	var starfield_texture = ImageTexture.new()
	var starfield_image = Image.new()
	var star_image = Image.new()
	var star_image_array = []
	var s
	var c
	
	star_image.load("res://Background/StarA.png")
	print("Generating Stars")
	starfield_image.create(wide,high,false,Image.FORMAT_RGBA8)
	starfield_image.fill(Color(.1,0,0,1))
	starfield_texture.create_from_image(starfield_image);

	for i in 1000:
		starfield_texture.draw(
			star_image.get_rid(),
			Vector2(randf() * wide,randf() * high),
			Color(1,1,1,1), 
			false		
		)

	texture = starfield_texture
	
	set_position(Vector2(wide * .5, high * .5))
