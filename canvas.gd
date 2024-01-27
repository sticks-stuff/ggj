extends ColorRect


var width = 50
var height = 50
var pixels = []
var pixel_height = get_size().y / width
var pixel_width = get_size().x / height


# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(height):
		var line = []
		for x in range(height):
			line.append(null)
		pixels.append(line)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()

func _draw():
	var line_num = 0
	for line in pixels:
		var pixel_num = 0
		for pixel in line:
			var color = pixel
			if color == null:
				color = Color.WHITE
			draw_rect(Rect2(pixel_num * pixel_width, line_num * pixel_height, pixel_width, pixel_height), color)
			pixel_num += 1
		line_num += 1

func draw_pixel_line(mouse_pos1, mouse_pos2, color):
	var pos1 =  Vector2((mouse_pos1.x - self.position.x) / pixel_width, (mouse_pos1.y - self.position.y) / pixel_height)
	var pos2 =  Vector2((mouse_pos2.x - self.position.x) / pixel_width, (mouse_pos2.y - self.position.y) / pixel_height)
	# https://en.wikipedia.org/wiki/Line_drawing_algorithm#:~:text=A%20naive%20line%2Ddrawing%20algorithm%5Bedit%5D
	var dx = pos2.x - pos1.x
	var dy = pos2.y - pos1.y
	if dx == 0:
		# Vertical line
		for y in range(min(pos1.y, pos2.y), max(pos1.y, pos2.y)):
			pixels[y][pos1.x] = color
	else:
		# Non-vertical line
		for x in range(min(pos1.x, pos2.x), max(pos2.x, pos1.x)):
			var y = pos1.y + dy * (x - pos1.x) / dx    
			pixels[y][x] = color
