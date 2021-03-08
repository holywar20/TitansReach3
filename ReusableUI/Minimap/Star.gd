extends TextureRect

var myStar : StarResource

func setupScene( star : StarResource ):
	myStar = star
	
	var myTexture = load( myStar.textureIconPath )
	set_texture( myTexture )

