extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const ROLLSPEED = 250
const ROLLFRAMES = 20

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var rolling = false
var rolling_frames = 0

var facing = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
		facing = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		facing = -1
		
	#Rolling Logic
	if rolling == true:
		rolling_frames += 1
	elif Input.is_action_just_pressed("roll"):
		rolling = true
		rolling_frames = 0
		print("rolling!")
	if rolling_frames >= ROLLFRAMES:
		rolling = false
	
		
		
	#Play Animations
	if is_on_floor():
		if rolling == true:
			animated_sprite.play("roll")
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	#Acutal Movement
	if !rolling:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = facing * ROLLSPEED

	move_and_slide()
