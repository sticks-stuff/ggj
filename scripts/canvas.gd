extends ColorRect

@export var canvas_size = Vector2i(50, 50)
var width = canvas_size.x
var height = canvas_size.y
var pixels = []
var pixel_height = get_size().y / width
var pixel_width = get_size().x / height


# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(height):
		var line = []
		for x in range(height):
			line.append(Color.TRANSPARENT)
		pixels.append(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()

func _draw() -> void:
	var line_num = 0
	for line in pixels:
		var pixel_num = 0
		for pixel in line:
			var color = pixel
			if color != null:
				draw_rect(Rect2(pixel_num * pixel_width, line_num * pixel_height, pixel_width, pixel_height), color)
			pixel_num += 1
		line_num += 1

func draw_pixel_line(mouse_pos1, mouse_pos2, color) -> void:
	var pos1 = mouse_to_pixel_pos(mouse_pos1)
	var pos2 = mouse_to_pixel_pos(mouse_pos2)
	
	# If mouse out of bounds, ignore.
	if pos1.x < 0 or pos1.x >= width or pos1.y < 0 or pos1.y >= height \
	or pos2.x < 0 or pos2.x >= width or pos2.y < 0 or pos2.y >= height:
		return
	
	for point in daa(pos1.x, pos1.y, pos2.x, pos2.y):
		pixels[point.y][point.x] = color

func mouse_to_pixel_pos(mouse_pos) -> Vector2:
	return Vector2((mouse_pos.x - self.position.x) / pixel_width, (mouse_pos.y - self.position.y) / pixel_height).floor()

# Digital Differential Analyzer Line Drawing Algorithm
func daa(x1, y1, x2, y2) -> Array[Vector2]:
	var dx = x2 - x1
	var dy = y2 - y1
	var steps = max(abs(dx), abs(dy))
	var Xinc = dx / float(steps)
	var Yinc = dy / float(steps)
	var X = x1
	var Y = y1
	var points: Array[Vector2] = []
	for i in range(steps+1):
		points.append(Vector2(round(X), round(Y)))
		X += Xinc
		Y += Yinc
	return points

func draw_pixel_fill(mouse_pos, color) -> void:
	var init_pos = mouse_to_pixel_pos(mouse_pos)
	if init_pos.x < 0 or init_pos.x >= width or init_pos.y < 0 or init_pos.y >= height:
		return
	var init_color = pixels[init_pos.y][init_pos.x] # color to be replaced
	if init_color == color:
		return

	var queue = [init_pos]
	while len(queue) > 0:
		var pos = queue.pop_front()
		if pos.x < 0 or pos.x >= width or pos.y < 0 or pos.y >= height or pixels[pos.y][pos.x] != init_color:
			continue
		pixels[pos.y][pos.x] = color
		queue.append(Vector2(pos.x + 1, pos.y))
		queue.append(Vector2(pos.x - 1, pos.y))
		queue.append(Vector2(pos.x, pos.y + 1))
		queue.append(Vector2(pos.x, pos.y - 1))


# Honestly, I have no clue if this works or how to test it!
#func get_image() -> Texture2D:
	#var texture = Texture2D.new()
	#for x in range(width):
		#for y in range(height):
			#texture.draw_rect(Rect2(), Vector2(x,y), pixels[y][x])
	#return texture
