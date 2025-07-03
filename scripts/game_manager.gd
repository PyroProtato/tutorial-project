extends Node

@onready var player: CharacterBody2D = $"../Player"
@onready var interact_sound: AudioStreamPlayer2D = $InteractSound

var score = 0
var health = 100

var state = "game"


func add_point():
	score += 1
	#score_label.text = "Coins: " + str(score)

func lose_health(amount):
	health -= amount
	print(health)
	player.take_damage(health)
	
#func _process(delta: float) -> void:
#	if health <= 0:
#		print("You Died!")
#		Engine.time_scale = 0.5
#		body.get_node("CollisionShape2D").queue_free()
#		timer.start()
