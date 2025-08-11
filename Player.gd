extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = 400.0
@export var gravity: float = 1000.0

func _physics_process(delta: float) -> void:
    var velocity = Vector2.ZERO

    # Handle horizontal movement
    if Input.is_action_pressed("ui_right"):
        velocity.x += speed
    elif Input.is_action_pressed("ui_left"):
        velocity.x -= speed

    # Handle jumping
    if is_on_floor() and Input.is_action_just_pressed("ui_up"):
        velocity.y = -jump_velocity

    # Apply gravity
    velocity.y += gravity * delta

    # Move the character
    move_and_slide(velocity, Vector2.UP)
    move_and_slide()