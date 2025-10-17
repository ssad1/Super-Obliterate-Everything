extends Control

var credits = 0
var credit_clock = 0.0
var bright = .8
@onready var credits_label = $Credits_Label
@onready var anim = $Sprite2D/AnimationPlayer

func _ready():
	anim.stop(true)

func _process(delta):
	if(credits != ACCOUNT.credits):
		credit_clock = credit_clock + delta
	if(credit_clock > .05):
		credit_clock = credit_clock - .05
		if(credits < ACCOUNT.credits):
			credits = credits + 1
		if(credits < ACCOUNT.credits - 10):
			credits = credits + 10
		if(credits < ACCOUNT.credits - 100):
			credits = credits + 100
		if(credits > ACCOUNT.credits):
			credits = credits - 1
		if(credits > ACCOUNT.credits + 10):
			credits = credits - 10
		if(credits > ACCOUNT.credits + 100):
			credits = credits - 100
	if(credits != ACCOUNT.credits):
		bright = 2
		if(anim.is_playing() == false):
			anim.play("Coin_Spin")
	else:
		bright = bright - 4 * delta
	if(bright < 0.8):
		bright = 0.8
	credits_label.text = "CREDITS:    " + str(credits)
	credits_label.modulate = Color(1,1,1,bright)
	#scale = Vector2(bright + .2, bright + .2)

func _on_anim_finished():
	print("ANIM FINISHED")
	if(credits == ACCOUNT.credits):
		print("STOPPING ANIM")
		anim.stop()
