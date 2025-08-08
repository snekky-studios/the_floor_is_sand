class_name Grid
extends Node2D

const PIXEL : Resource = preload("res://resources/pixel/pixel.gd")

const NUM_ROWS : int = 64
const NUM_COLS : int = 64

var image : Image = preload("res://assets/sprites/pixel/base.png")

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

func get_pixel_type(coordinate : Vector2i) -> Pixel.Type:
	return pixels_current[coordinate].type

func set_pixels(coordinate_list : Array[Vector2i], new_type : Pixel.Type) -> void:
	for coordinate : Vector2i in coordinate_list:
		pixels_current[coordinate].type = new_type
		pixels_next[coordinate].type = new_type
		set_image_pixel(coordinate, pixels_current[coordinate].type)
	return

func set_pixels_block(coordinate_start : Vector2i, coordinate_end : Vector2i, new_type : Pixel.Type) -> void:
	for row : int in range(coordinate_start.y, coordinate_end.y):
		for col : int in range(coordinate_start.x, coordinate_end.x):
			var coordinate : Vector2i = Vector2i(col, row)
			pixels_current[coordinate].type = new_type
			pixels_next[coordinate].type = new_type
			set_image_pixel(coordinate, pixels_current[coordinate].type)
	return

func set_pixel(coordinate : Vector2i, new_type : Pixel.Type) -> bool:
	var result : bool = false
	if(pixels_current[coordinate].type != new_type):
		pixels_current[coordinate].type = new_type
		pixels_next[coordinate].type = new_type
		result = true
	set_image_pixel(coordinate, pixels_current[coordinate].type)
	return result

func set_image_pixel(coordinate : Vector2i, type : Pixel.Type) -> void:
	image.set_pixel(coordinate.x, coordinate.y, Pixel.PixelColor[pixels_current[coordinate].type])
	return

# resets all pixels to Type.NONE
func reset() -> void:
	set_pixels_block(Vector2i.ZERO, Vector2i(NUM_COLS, NUM_ROWS), Pixel.Type.NONE)
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

func get_sand_level(col : int) -> int:
	var sand_level : int = 0
	while(sand_level < NUM_COLS and pixels_current[Vector2i(col, sand_level)].type == Pixel.Type.NONE):
		sand_level += 1
	return sand_level
