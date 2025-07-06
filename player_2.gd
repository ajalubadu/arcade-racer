extends CharacterBody2D
@export var schneller = 100

func _process(delta: float) -> void:
	velocity = Input.get_vector("left","rechts","UP","dOWN")*schneller
	move_and_slide()
