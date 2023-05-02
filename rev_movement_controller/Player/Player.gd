extends CharacterBody2D

@onready var ground_ray = $GroundRay
@onready var sprite = $Sprite

@export var speed : float = 400.0
@export var gravity : float = 980.0
## higher values = faster slow down time
@export var slowdown_time : float = 3000.0
@export var wall_slide : float = 50.0
@export var wall_jump_vertical_velocity : float = 500.0

@export var jumps : int = 1

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity() * delta
	
	jump(delta)
	
	# mapped to "A" and "D" keys in project settings
	var direction = Input.get_axis("left", "right")
			
	if direction:
		# starts movement
		velocity.x = direction * speed
	else:
		if is_on_floor():
			# stops movement
			velocity.x = move_toward(velocity.x, 0, slowdown_time * delta)
		
	move_and_slide()
	
func jump(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if not Input.is_action_pressed("jump") and not is_on_floor():
		velocity.y += get_gravity() * delta
			
	# make player stick to the wall by making the y velocity a low value
	if is_on_wall() and not ground_ray.is_colliding():
		velocity.y = wall_slide
		
		if Input.is_action_just_pressed("jump"):
			velocity.x = get_wall_normal().x * wall_jump_vertical_velocity 
			velocity.y = jump_velocity
	
