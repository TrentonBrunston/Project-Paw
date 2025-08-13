extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = 400.0
const GRAVITY = 800.0

func _physics_process(delta):
    # Apply gravity
    if not is_on_floor():
        velocity.y += GRAVITY * delta

    # Handle horizontal movement
    var direction = 0
    if Input.is_action_pressed("ui_right"):
        direction += 1
    if Input.is_action_pressed("ui_left"):
        direction -= 1
    velocity.x = direction * SPEED

    # Jumping
    if Input.is_action_just_pressed("ui_up") and is_on_floor():
        velocity.y = -JUMP_FORCE

    # Move and slide
    move_and_slide()
