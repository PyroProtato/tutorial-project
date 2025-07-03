extends Area2D

@onready var timer: Timer = $Timer
@onready var game_manager: Node = get_node("/root/Game/GameManager")
@onready var player: CharacterBody2D = get_node("/root/Game/Player")

@export var damage_amount: int = 100


func _on_body_entered(body: Node2D) -> void:
	game_manager.lose_health(damage_amount)
	
	if game_manager.health <= 0:
		print("You Died!")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	



func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
