extends CharacterBody2D

const GRAVITY = 5000.0
const JUMP_SPEED = -1800.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_SPEED
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")

	move_and_slide()
