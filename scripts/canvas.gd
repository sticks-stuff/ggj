extends ColorRect

@export var canvas_size = Vector2i(50, 50)
var width = canvas_size.x
var height = canvas_size.y
var pixels = []
var pixel_height = get_size().y / width
var pixel_width = get_size().x / height

var undo_stack = []
var changed_since_undo_state = false # Stores true if changes have been made to the pixel canvas since the last undo state was recorded

func record_undo_state():
	if changed_since_undo_state:
		print("recorded undo state")
		undo_stack.append(pixels.duplicate(true))
		changed_since_undo_state = false

func undo():
	if len(undo_stack) >= 2:
		print("undoing")
		undo_stack.pop_back() # current
		pixels = undo_stack[-1].duplicate(true) # last

# Called when the node enters the scene tree for the first time.
func _ready():
	var mid = canvas_size / 2
	var radius = canvas_size.x * 0.45
	for y in range(height):
		var line = []
		for x in range(height):
			var color = Color.TRANSPARENT
			if Vector2(x, y).distance_to(mid) <= radius:
				color = Color.RED
			line.append(color)
		pixels.append(line)
	undo_stack.append(pixels.duplicate(true))

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
	if pos1 == null or pos2 == null:
		return
	
	for point in daa(pos1.x, pos1.y, pos2.x, pos2.y):
		pixels[point.y][point.x] = color
		changed_since_undo_state = true
	

# Converts the mouse position on screen to a position on the pixel canvas. Or returns null if its no on the screen.
func mouse_to_pixel_pos(mouse_pos):
	var pos = Vector2((mouse_pos.x - self.position.x) / pixel_width, (mouse_pos.y - self.position.y) / pixel_height).floor()
	if pos.x < 0 or pos.x >= canvas_size.x or pos.y < 0 or pos.y >= canvas_size.y:
		return null
	return pos

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
	# If mouse out of bounds, ignore.
	if init_pos == null:
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
		changed_since_undo_state = true
		queue.append(Vector2(pos.x + 1, pos.y))
		queue.append(Vector2(pos.x - 1, pos.y))
		queue.append(Vector2(pos.x, pos.y + 1))
		queue.append(Vector2(pos.x, pos.y - 1))

# Saves the 2d array of pixels to a png file and returns the path of that file
func save_image() -> String:
	var path: String = "user://image.png"
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	for x in range(width):
		for y in range(height):
			image.set_pixel(x, y, pixels[y][x])
	var error = image.save_png(path)
	if error == OK:
		print("Saved image to: ", path)
	else:
		print("Failed to save image, error code: ", error)
	return path
