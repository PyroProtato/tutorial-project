extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

const ROLLSPEED = 250
const ROLLFRAMES = 20

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager: Node = %GameManager

var rolling = false
var rolling_frames = 0

var taking_damage = false
var damage_frames = 0
var DAMAGE_FRAMES = 20
var DAMAGE_SPEED_MULT = 0.5

var facing = 1
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound

func take_damage(health):
	if health > 0:
		taking_damage = true
		damage_frames = 0
		damage_sound.play()
	else:
		death_sound.play()


func _physics_process(delta: float) -> void:
	if game_manager.state == "game":
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()

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
			dash_sound.play()
		if rolling_frames >= ROLLFRAMES:
			rolling = false
		
			
			
		#Play Animations
		if !taking_damage:
			if is_on_floor():
				if rolling == true:
					animated_sprite.play("roll")
				elif direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
		else:
			animated_sprite.play("damage")
			if damage_frames < DAMAGE_FRAMES:
				damage_frames += 1
			else:
				taking_damage = false
			
		
		#Acutal Movement
		if !rolling:
			if direction:
				velocity.x = direction * SPEED
				if taking_damage:
					velocity.x *= DAMAGE_SPEED_MULT
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = facing * ROLLSPEED

		move_and_slide()
