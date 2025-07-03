extends Area2D

@export var text: String = "This is a sign"
@onready var game_manager: Node = %GameManager

@onready var sign_background: Node = get_node("/root/Game/HUD/SignHUD/CenterContainer/SignBackground")
@onready var sign_text: Label = get_node("/root/Game/HUD/SignHUD/SignText")

var enter_sign = false
var exit_sign = false

var interactible = false


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("interact") and interactible:
		#Runs right as sign is opened
		if game_manager.state == "game":
			sign_background.visible = true
			sign_text.visible = true
			game_manager.state = "sign"
			game_manager.interact_sound.play()
			sign_text.text = text
			
		#Runs right as sign is closed
		elif game_manager.state == "sign":
			game_manager.state = "game"
			sign_background.visible = false
			sign_text.visible = false
			game_manager.interact_sound.play()
	

	
	


func _on_body_entered(_body: Node2D) -> void:
	interactible = true
	

func _on_body_exited(_body: Node2D) -> void:
	interactible = false
