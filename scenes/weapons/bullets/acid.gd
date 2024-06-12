extends Bullet

@onready var lifespan_timer : Timer = $LifespanTimer
@onready var glow : PointLight2D = $Glow
@onready var normal_getter : RayCast2D = $NormalGetter

@export var color : Color
@export var collision_sound : AudioStreamWAV
var grav : float = randf_range(1000, 1400)

var landed : bool = false

var y_velocity : Vector2 = Vector2()  # Bullet's initial velocity

var new_trail : Line2D
# Called when the node enters the scene tree for the first time.
func _ready():
	new_trail = trail.instantiate()
	add_sibling(new_trail)
	lifespan_timer.start(lifespan)
	rotate(direction.angle())
	new_trail.modulate = color
	modulate = color
	glow.color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if landed == false:
		# Apply gravity to the velocity (only in the y-direction)
		y_velocity.y += grav * delta
		global_position += y_velocity * delta
		global_position += direction * (delta * velocity)
		global_position += Vector2(randf_range(-2, 2), randf_range(-1, 1))

		new_trail.add_new_point(position)
	for area in self.get_overlapping_areas():
		if(area.name == "Hurtbox"):
			area.get_parent().acid_damage(self)


func _on_lifespan_timer_timeout():
	queue_free()


func _on_body_entered(body):
	landed = true
	var new_explosion : Node2D = explosion.instantiate()
	new_explosion.position = position
	normal_getter.force_raycast_update()
	new_explosion.rotation = normal_getter.get_collision_normal().angle() + PI/2
	add_sibling(new_explosion)
	var sound = AudioStreamPlayer2D.new()
	sound.position = position
	sound.stream = collision_sound
	sound.finished.connect(sound.queue_free)
	add_sibling(sound)
	sound.play()
	new_trail.queue_free()
	#queue_free()
	pass # Replace with function body.
