extends AnimatedSprite

var duration = 0

func checkDuration():
	if( duration > 0 ):
		duration = duration - 1
	else:
		queue_free()
