extends Camera2D

@export var default_zoom: float
@export var enable_zoom: bool
@export var min_zoom: float
@export var max_zoom: float

## the amount of zoom for each scroll
@export var zoom_amount: float

var scroll_zoom: float = default_zoom
var current_zoom: Vector2
var lerp_zoom_value = zoom

func _ready():
	current_zoom = Vector2(default_zoom, default_zoom)
	zoom = current_zoom

func clamp_zoom_value(zoom_value: float) -> Vector2:
	var new_zoom_value = clamp(zoom_value, min_zoom, max_zoom)
	return Vector2(new_zoom_value, new_zoom_value)

func _unhandled_input(event) -> void:	
	if enable_zoom:
		
			# handle trackpad scrolling 
		if event is InputEventPanGesture:
			# zoom out
			if event.delta.y > 0:
				scroll_zoom += zoom_amount
				current_zoom = clamp_zoom_value(scroll_zoom)
				
				if scroll_zoom > max_zoom:
					scroll_zoom = max_zoom
			
			# zoom in
			if event.delta.y < 0:
				scroll_zoom -= zoom_amount
				current_zoom = clamp_zoom_value(scroll_zoom)
				
				if scroll_zoom < min_zoom:
					scroll_zoom = min_zoom
	
func _physics_process(delta):
	zoom = lerp(zoom, current_zoom, 1.0)
