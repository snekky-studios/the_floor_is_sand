class_name Pixel
extends Resource

const COLOR_WHITE : Color = Color(0.937, 0.976, 0.839)
const COLOR_ORANGE : Color = Color(0.729, 0.314, 0.267)
const COLOR_RED : Color = Color(0.478, 0.11, 0.294)
const COLOR_BLACK : Color = Color(0.106, 0.012, 0.149)
const COLOR_NONE : Color = Color(1.0, 1.0, 1.0, 0.0)

enum Type
{
	SAND,
	WALL,
	NONE
}

const PixelColor : Dictionary[Type, Color] = {
	Type.SAND : COLOR_ORANGE,
	Type.WALL : COLOR_RED,
	Type.NONE : COLOR_BLACK
}

var type : Type = Type.NONE
