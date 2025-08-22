extends CharacterBody2D

var speed = 120.0
var jump_velocity = -475.0
var gravity = 2300
var jumptween
var jumping = false
var hasjumped = false # just an extra failsafe so that when the player falls but has not yet jumped won't crash the game, shouldnt happen but whoever tests it would find the crash if i didnt fix it
var haswrench = false

func _ready():
	print(get_tree().current_scene)
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jumping = false
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, gravity)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
		gravity = 2300
		jumptween = get_tree().create_tween()
		jumptween.tween_property(self, "gravity", 750, 0.2)
		jumptween.play()
		$AnimatedSprite2D.play("jump")
		velocity.y += jump_velocity
		hasjumped = true
		
	if Input.is_action_pressed("run"):
		speed = 160.0
		$AnimatedSprite2D.speed_scale = 2.0
	else:
		speed = 120.0
		$AnimatedSprite2D.speed_scale = 1.0
	
	if Input.is_action_just_released("jump") and hasjumped:
		jumptween.stop()
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if not jumping:
			$AnimatedSprite2D.play("walk")
		if direction > 0.0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity == Vector2(0,0):
			$AnimatedSprite2D.animation = "default"
		
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, gravity)
	move_and_slide()


func _on_wrench_body_entered(body: Node2D) -> void:
	haswrench = true
	get_parent().get_node("Wrench").queue_free()


func _on_radio_tower_body_entered(body: Node2D) -> void:
	if !haswrench:
		$Camera2D/Tutorial/TextureRect4.visible = true
		$Camera2D/Tutorial/TextureRect4/RichTextLabel.text = "Get the wrench before progressing to the next level"
		await get_tree().create_timer(2).timeout
		$Camera2D/Tutorial/TextureRect4.visible = false
	else:
		if get_tree().current_scene.name == "Level1":
			get_tree().change_scene_to_file('res://level2.tscn')
		elif get_tree().current_scene.name == "Level2":
			get_tree().change_scene_to_file("res://end.tscn")
