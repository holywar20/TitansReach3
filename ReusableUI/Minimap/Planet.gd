extends TextureRect

var myPlanet : PlanetResource

func setupScene( newPlanet : PlanetResource ):
	myPlanet = newPlanet
	set_self_modulate(  ColorN( myPlanet.pColor, 1 ) )
