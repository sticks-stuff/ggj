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
	var pos1 = Vector2((mouse_pos1.x - self.position.x) / pixel_width, (mouse_pos1.y - self.position.y) / pixel_height).floor()
	var pos2 = Vector2((mouse_pos2.x - self.position.x) / pixel_width, (mouse_pos2.y - self.position.y) / pixel_height).floor()
	
	# If mouse out of bounds, ignore.
	if pos1.x < 0 or pos1.x >= width or pos1.y < 0 or pos1.y >= height or pos2.x < 0 or pos2.x > width or pos2.y < 0 or pos2.y >= height:
		return
	
	for point in daa(pos1.x, pos1.y, pos2.x, pos2.y):
		pixels[point.y][point.x] = color

# Digital Differential Analyzer Line Drawing Algorithm
func daa(x1, y1, x2, y2):
	var dx = x2 - x1
	var dy = y2 - y1
	var steps = max(abs(dx), abs(dy))
	var Xinc = dx / float(steps)
	var Yinc = dy / float(steps)
	var X = x1
	var Y = y1
	var points = []
	for i in range(steps+1):
		points.append(Vector2(round(X), round(Y)))
		X += Xinc
		Y += Yinc
	return points
