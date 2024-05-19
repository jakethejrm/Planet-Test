@tool
extends GravObject

@export_group("Planet")
@export_range(0, 1000, 50) var planet_size: float = 100 : set = _set_planet_size
@export var planet_type : PlanetTypes.planets = PlanetTypes.planets.EARTH : set = _set_planet_type

var planet_color = Color.ORANGE

func gravity_force(player : Node2D) -> Vector2:
	return(position - player.position).normalized() * gravity_amount

func _on_gravity_source_body_entered(body):
	if body.name == "Player":
		body.grav_source = self

func _set_planet_size(new_size : float):
	planet_size = new_size
	# adjusting area radii
	$GravitySource/GravityField.shape.radius = planet_size + 100
	$PlanetSurface/PlanetCollision.shape.radius = planet_size
	
	#creating new planet polygon
	#TODO: Polygon UVs
	var new_polygon = []
	var polygon_uvs = []
	for i in range(new_size):
		var x : float = cos(2*PI * (i/new_size))
		var y : float = sin(2*PI * (i/new_size))
		new_polygon.append(Vector2(x * new_size, y  * new_size))
		polygon_uvs.append(Vector2(x * 128 + 128, y * 128 + 128))
	$PlanetSurface/PlanetGeometry.polygon = new_polygon
	$PlanetSurface/PlanetGeometry.uv = polygon_uvs
	
	#remove all previous grass
	for child in $PlanetDetails.get_children():
		child.queue_free()
	
	
	#grass time
	for i in range(new_size):
		var grass
		var env_rand = randf()
		if env_rand > 0.2:
			grass = preload("res://scenes/decor/grass.tscn").instantiate()
		elif env_rand > 0.1:
			grass = preload("res://scenes/decor/flower.tscn").instantiate()
		elif env_rand > 0.08:
			grass = preload("res://scenes/decor/tree.tscn").instantiate()
		else:
			grass = preload("res://scenes/decor/rock.tscn").instantiate()
		var x = cos(2*PI * (i/new_size)) * new_size
		var y = sin(2*PI * (i/new_size)) * new_size
		grass.position = Vector2(x,y)
		grass.rotation = 2*PI * (i/new_size) + PI/2
		$PlanetDetails.add_child(grass)
		if is_visible_in_tree():
			var root = get_tree().edited_scene_root
			grass.owner = root
			
	# updating planet shader
	$PlanetSurface/PlanetGeometry.material.set("shader_parameter/planet_size", new_size)
	
	# updating atmosphere
	var atmosphere = $PlanetSurface/Atmosphere as Sprite2D
	var texture = atmosphere.texture as GradientTexture2D
	atmosphere.texture.height = new_size * 2 * 2
	atmosphere.texture.width = new_size * 2 * 2
	pass 
	
func _set_planet_type(new_type : PlanetTypes.planets):
	planet_type = new_type
	match new_type:
		PlanetTypes.planets.EARTH:
			$PlanetSurface/PlanetGeometry.texture = preload("res://materials/planet.png")
	pass
