@tool
extends GravObject

@export var width : float = 200 : set = _set_width
@export var height : float = 200: set = _set_height

func gravity_force(player : Node2D) -> Vector2:
	return gravity_amount * Vector2.DOWN.rotated(rotation)
	
func _on_gravity_body_entered(body):
	if body.name == "Player":
		body.grav_source = self
		body.up_direction = Vector2.UP.rotated(rotation)

func _set_width(new_width : float):
	width = new_width
	var half = new_width * 0.5
	var polygon_array : Array[Vector2] = []
	for point in $Sprite.polygon:
		polygon_array.append(Vector2(sign(point.x) * half, point.y))
	$Sprite.polygon = polygon_array
	
	$Sprite.material.set("shader_parameter/dimensions", Vector2(new_width, height))
	
	# collision
	$Collision.polygon = polygon_array.map(func(vec : Vector2): return Vector2(vec.x - (sign(vec.x) * 8), vec.y))
	
	# gravity field
	$Gravity/CollisionShape2D.shape.size = Vector2(new_width,50)
	
	# grass
	for child in $Details.get_children():
		child.queue_free()
	
	for i in range(width / 8 - 2):
		var env_rand = randf()
		var grass : Node2D
		if env_rand > 0.2:
			grass = preload("res://scenes/decor/grass.tscn").instantiate()
		elif env_rand > 0.1:
			grass = preload("res://scenes/decor/flower.tscn").instantiate()
		elif env_rand > 0.08:
			grass = preload("res://scenes/decor/tree.tscn").instantiate()
		else:
			grass = preload("res://scenes/decor/rock.tscn").instantiate()
		grass.position = Vector2(-half + 8 + (8 * i), 0)
		$Details.add_child(grass)
		if is_visible_in_tree():
			var root = get_tree().edited_scene_root
			grass.owner = root
	
func _set_height(new_height : float):
	height = new_height
	var half = new_height * 0.5
	var polygon_array : Array[Vector2] = []
	for point in $Sprite.polygon:
		polygon_array.append(Vector2( point.x, sign(point.y) * half))
	$Sprite.polygon = polygon_array
	$Sprite.position = Vector2(0, height / 2)
	$Sprite.material.set("shader_parameter/dimensions", Vector2(width, new_height))

	$Collision.polygon = polygon_array.map(func(vec : Vector2): return Vector2(vec.x - (sign(vec.x) * 8), vec.y))
	$Collision.position = $Sprite.position
