extends CharacterBody2D

const SPEED = 160.0
var jump_velocity = -475.0
var gravity = 2300
var jumptween
signal changegravity


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, gravity)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = 2300
		jumptween = get_tree().create_tween()
		jumptween.tween_property(self, "gravity", 750, 0.2)
		jumptween.play()
		velocity.y += jump_velocity
		
	if Input.is_action_just_released("jump"):
		jumptween.stop()
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, gravity)
	move_and_slide()
