extends Node

#----------Flow variables-----------
const GameSource = preload("res://game/game_source.gd")

var main_node: Node  # Injection on main, Used to instance nodes on it.
var game: GameSource
var game_thread: Thread
var mutex: Mutex
var semaphore: Semaphore # post when result is ready
var main_result: Variant


#-----------State Variables---------------
enum {
	FrontBuffer,
	BackBuffer,
}

var auto_mid_handle: bool
var clear_color: Color
var active_color: Color
var active_font: BBFont
var sprite_rendering_queue: Array # [[image, id, x, y], [image, id, x, y]]
var text_rendering_queue: Array


func _ready() -> void:
	# Run game
	game = GameSource.new()
	game_thread = Thread.new()
	game_thread.start(game.entry)
	mutex = Mutex.new()
	semaphore = Semaphore.new()


#---------Functions-----------
func Graphics(width: int, height: int, _color_depth: int, mode: int) -> void:
	# color_depth is set t 16. But the tutorial says to leave it empty.
	# I'll leave it unused and instead use the normal 32bit color format. 
	DisplayServer.window_set_size(Vector2(width, height))
	match mode:
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func SetBuffer(_buffer: int) -> void:
	# Do nothing. Godot knows to only render after the idle frames.
	pass


func AutoMidHandle(enable: bool) -> void:
	auto_mid_handle = enable


func LoadImage(path: String) -> BBImage:
	main_node.request_load.call_deferred("res://game".path_join(path))
	semaphore.wait()
	var image: Image = (main_result as Texture2D).get_image()
	
	image.convert(Image.FORMAT_RGBA8)
	var final = BBImage.new()
	final.original_image = image
	return final


func LoadAnimImage(path: String, width: int, height: int, \
		first: int, count: int) -> Array[BBImage]:
	main_node.request_load.call_deferred("res://game".path_join(path))
	semaphore.wait()
	var original_image = (main_result as Texture2D).get_image()
	original_image.convert(Image.FORMAT_RGBA8)
	@warning_ignore("integer_division")
	var h_count: int = original_image.get_size().x/width
	@warning_ignore("integer_division")
	var v_count: int = original_image.get_size().y/height
	
	var images: Array[BBImage]
	for v in v_count:
		for h in h_count:
			var frame = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
			
			# Copy the pixels
			for y in height:
				for x in width:
					var pixel = original_image.get_pixel(x + (h * width), y + (v * height))
					frame.set_pixel(x, y, pixel)
			
			var bbimage = BBImage.new()
			bbimage.original_image = frame
			images.append(bbimage)
	return images.slice(first, count)


func Rnd(minimum: int, maximum: int) -> int:
	return randi_range(minimum, maximum)


func LoadSound(path: String) -> BBSound:
	var bbsound = BBSound.new()
	main_node.request_load.call_deferred("res://game".path_join(path.to_lower()))
	semaphore.wait()
	bbsound.audio = main_result as AudioStream
	bbsound.loop = false
	return bbsound
	

func LoadFont(font_name: String, height: int = 12, bold: bool = false, \
		italic: bool = false, underlined: bool = false) -> BBFont:
	
	main_node.request_load.call_deferred("res://game/" + font_name + ".otf")
	semaphore.wait()
	var font = BBFont.new()
	font.font_file = main_result
	font.height = height
	font.bold = bold
	font.italic = italic
	font.underlined = underlined
	return font


func LoopSound(sound: BBSound) -> void:
	sound.loop = true


func PlaySound(sound: BBSound) -> BBSoundChannel:
	main_node.play_sound.call_deferred(sound.audio, sound.loop)
	semaphore.wait()
	var channel = BBSoundChannel.new()
	channel.player = main_result
	return channel
	

func ChannelPitch(channel: BBSoundChannel, pitch: int):
	channel.player.set_pitch_scale.call_deferred(float(pitch)/22_000.0)


func ClsColor(r: int, g: int, b: int) -> void:
	clear_color = Color(float(r)/255.0, float(g)/255.0, float(b)/255.0)


func MaskImage(image:BBImage, r: int, g: int, b: int) -> void:
	image.mask_color = Color(float(r)/255.0, float(g)/255.0, float(b)/255.0)
	
	image.masked_image = image.original_image.duplicate()
	for y in image.masked_image.get_size().y:
		for x in image.masked_image.get_size().x:
			var pixel: Color = image.original_image.get_pixel(x, y)
			if pixel.is_equal_approx(image.mask_color):
				image.masked_image.set_pixel(x, y, Color.TRANSPARENT)


func Cls() -> void:
	RenderingServer.set_default_clear_color(clear_color)
	sprite_rendering_queue.clear()
	text_rendering_queue.clear()


func KeyDown(scancode: int) -> bool:
	main_node.is_key_down.call_deferred(scancode)
	semaphore.wait()
	return main_result


func End() -> void:
	main_node.end.call_deferred()
	semaphore.wait()


func DrawImage(image: BBImage, x: int, y: int) -> void:
	var image_to_use: Image
	if image.masked_image:
		image_to_use = image.masked_image
	else:
		image_to_use = image.original_image
	var entry = [image_to_use, image.unique_id, x, y]
	sprite_rendering_queue.append(entry)
	

func Flip() -> void:
	main_node.process_sprite_queue.call_deferred(sprite_rendering_queue, auto_mid_handle)
	main_node.process_text_queue.call_deferred(text_rendering_queue)


func SetFont(font: BBFont) -> void:
	active_font = font


func BBColor(r: int, g: int, b: int) -> void:
	active_color = Color(float(r)/255.0, float(g)/255.0, float(b)/255.0)


func Text(x: int, y: int, string: String, center_x: int, center_y: int) -> void:
	var entry = [x, 
			y,
			string,
			bool(center_x),
			bool(center_y),
			active_font.font_file,
			active_font.height,
			active_font.bold,
			active_font.italic,
			active_font.underlined,
			active_color,
			]
	text_rendering_queue.append(entry)



class BBImage:
	var original_image: Image
	var masked_image: Image # Must be updated when MaskImage is called
	var mask_color: Color = Color.BLACK # Must be updated when MaskImage is called
	var unique_id: int
	func _init() -> void:
		unique_id = randi()

class BBSoundChannel:
	var player: AudioStreamPlayer

class BBSound:
	var audio: AudioStreamWAV
	var loop: bool

class BBFont:
	var font_file: FontFile
	var height: int
	var bold: bool
	var italic: bool
	var underlined: bool
