class_name Grid
extends Node2D

const PIXEL : Resource = preload("res://resources/pixel/pixel.gd")

const NUM_ROWS : int = 64
const NUM_COLS : int = 64

var image : Image = Image.load_from_file("res://assets/sprites/pixel/base.png")

var pixels_current : Dictionary[Vector2i, Pixel] = {}
var pixels_next : Dictionary[Vector2i, Pixel] = {}

var sprite_2d : Sprite2D = null

func _ready() -> void:
	sprite_2d = %Sprite2D
	sprite_2d.texture = ImageTexture.create_from_image(image)
	
	# initialize pixel data
	for row : int in range(NUM_ROWS):
		for col : int in range(NUM_COLS):
			var pixel_current : Pixel = PIXEL.new()
			var pixel_next : Pixel = PIXEL.new()
			pixel_current.type = Pixel.Type.NONE
			pixel_next.type = Pixel.Type.NONE
			pixels_current[Vector2i(col, row)] = pixel_current
			pixels_next[Vector2i(col, row)] = pixel_next
	
	display()
	return

func _physics_process(delta: float) -> void:
	update()
	display()
	return

func display() -> void:
	for row : int in range(NUM_ROWS):
		for col : int in range(NUM_COLS):
			var coordinate : Vector2i = Vector2i(col, row)
			set_pixel(coordinate, pixels_current[coordinate].type)
	sprite_2d.texture = ImageTexture.create_from_image(image)
	return

func set_pixel_type(coordinate : Vector2i, new_type : Pixel.Type) -> void:
	pixels_current[coordinate].type = new_type
	set_pixel(coordinate, pixels_current[coordinate].type)
	return

func set_pixel(coordinate : Vector2i, type : Pixel.Type) -> void:
	image.set_pixel(coordinate.x, coordinate.y, Pixel.PixelColor[pixels_current[coordinate].type])
	return

func update() -> void:
	for row : int in range(NUM_ROWS - 1):
		for col : int in range(NUM_COLS):
			#var pixel_current : Pixel = pixels_current[row][col]
			if(pixels_current[Vector2i(col, row)].type == Pixel.Type.SAND):
				if(pixels_current[Vector2i(col, row + 1)].type == Pixel.Type.NONE):
					swap(Vector2i(col, row), Vector2i(col, row + 1))
				elif(col > 0 and pixels_current[Vector2i(col - 1, row + 1)].type == Pixel.Type.NONE and Time.get_ticks_usec() % 2 == 0):
					swap(Vector2i(col, row), Vector2i(col - 1, row + 1))
				elif(col < (NUM_COLS - 1) and pixels_current[Vector2i(col + 1, row + 1)].type == Pixel.Type.NONE):
					swap(Vector2i(col, row), Vector2i(col + 1, row + 1))
				elif(col > 0 and pixels_current[Vector2i(col - 1, row + 1)].type == Pixel.Type.NONE):
					swap(Vector2i(col, row), Vector2i(col - 1, row + 1))
	for row : int in range(NUM_ROWS):
		for col : int in range(NUM_COLS):
			pixels_current[Vector2i(col, row)].type = pixels_next[Vector2i(col, row)].type
	return

func swap(coordinate1 : Vector2i, coordinate2 : Vector2i) -> void:
	pixels_next[coordinate1].type = pixels_current[coordinate2].type
	pixels_next[coordinate2].type = pixels_current[coordinate1].type
	return
