extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("draft_error", Callable(self, "_draft_error"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draft_error(s):
	var q = randf()
	show()
	match(s):
		"POOR":
			if(q < 0.2):
				$Label.text = "TOO POOR!"
			if(q >= 0.2 && q < 0.4):
				$Label.text = "CAN'T AFFORD!"
			if(q >= 0.4 && q < 0.6):
				$Label.text = "INSUFFICIENT FUNDS!"
			if(q >= 0.6 && q < 0.8):
				$Label.text = "NEED CREDITS!"
			if(q >= 0.8):
				$Label.text = "GET A JOB!"
			
		"FULL":
			$Label.text = "INVENTORY FULL!"
	$Label2.text = $Label.text
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("New Anim")
