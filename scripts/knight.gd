extends CharacterBody2D

const GRAVITY = 3800.0
const JUMP_SPEED = -1400.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		$RunCol.disabled = false
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
			elif Input.is_action_pressed("ui_down"):
				$RunCol.disabled = true
				$AnimatedSprite2D.play("duck")
			else:
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")

	move_and_slide()
