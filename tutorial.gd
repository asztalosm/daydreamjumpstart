extends Control

func _ready() -> void:
	$TextureRect.visible = true
	await get_tree().create_timer(5.0).timeout
	$TextureRect.visible = false
	$TextureRect2.visible = true
	await get_tree().create_timer(5.0).timeout
	$TextureRect2.visible = false
	$TextureRect3.visible = true
	await get_tree().create_timer(5.0).timeout
	$TextureRect3.visible = false
	$TextureRect4.visible = true
	await get_tree().create_timer(5.0).timeout
	$TextureRect4.visible = false
